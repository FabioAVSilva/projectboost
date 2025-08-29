extends RigidBody3D

## How much vertical force to apply when boosting.
@export_range(750.0, 3000.0) var thrust: float = 1000.0

## How much rotational force to apply when rotating.
@export var torque: float = 100.0

var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var booster_particles_turn_left: GPUParticles3D = $BoosterParticlesTurnLeft
@onready var booster_particles_turn_right: GPUParticles3D = $BoosterParticlesTurnRight
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		rocket_audio.stop()
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque) * delta)
		booster_particles_turn_left.emitting = true
	else:
		booster_particles_turn_left.emitting = false
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque) * delta)
		booster_particles_turn_right.emitting = true
	else:
		booster_particles_turn_right.emitting = false	
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_body_entered(body: Node) -> void:
	if !is_transitioning:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)
		elif "Hazard" in body.get_groups():
			crash_sequence()
		

func crash_sequence() -> void:
	print("Kaboom!!")
	explosion_particles.emitting = true
	explosion_audio.play()
	rocket_audio.stop()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)
	
	
func complete_level(next_level_file: String) -> void:
	print("Level Complete")
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
