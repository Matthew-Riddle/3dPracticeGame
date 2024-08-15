extends Node3D
@onready var fps_camera = get_tree().get_root().get_node("TestMap/Player/PlayerSpatial/Camera3D")
@onready var rts_camera = $"../PlayerInterface/CameraBase/CameraSocket/Camera3D"
@onready var camera_toggle = false
# Called when the node enters the scene tree for the first time.
func _ready():
	rts_camera.make_current()
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("ui_camera_toggle"):
		if camera_toggle == false:
			fps_camera.active_script = true
			rts_camera.active_script = false
			fps_camera.make_current()
		else:
			rts_camera.active_script = true
			fps_camera.active_script = false
			rts_camera.make_current()
		camera_toggle = !camera_toggle
	#if Input.is_action_just_pressed("ui_camera_toggle") and fps_camera.is_current() == true:
		#rts_camera.make_current()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
