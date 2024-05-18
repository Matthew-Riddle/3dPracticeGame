extends Node3D
const LOOKAROUND_SPEED = .008
var rot_x = 0
var rot_y = 0
func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("ui_rotate"):
		#rot_x -= event.relative.x * LOOKAROUND_SPEED
		rot_y -= event.relative.y * LOOKAROUND_SPEED
		transform.basis = Basis()
		#rotate_object_local(Vector3(0, 1, 0), rot_x)
		rotate_object_local(Vector3(1, 0, 0), rot_y)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
