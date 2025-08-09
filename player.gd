extends Node3D
var spaces: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var my_number: int = 10
	print(my_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		spaces = spaces + 1
		print("Times spacebar was pressed:")
		print(spaces)
