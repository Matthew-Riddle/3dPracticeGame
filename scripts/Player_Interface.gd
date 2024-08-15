extends Node2D

# NODES
@onready var player_camera:Node3D = $CameraBase
@onready var player_camera_visibleunits_Area3D:Area3D = $CameraBase/VisibleUnitsArea3D
@onready var ui_drag_box:NinePatchRect = $UIDragbox

# Variables
@onready var BoxSelectionUnits_Visible:Dictionary = {}

# CONSTANTS
const min_drag_squared:int = 128

# Internal Variables
var mouse_left_click:bool = false
var drag_rectangle_area:Rect2
# {unit_id : unit_node}

func _ready():
	initialize_interface()

func unit_entered(unit:Node3D) -> void:
	var unit_id:int = unit.get_instance_id()
	if BoxSelectionUnits_Visible.keys().has(unit_id):return
	BoxSelectionUnits_Visible[unit_id] = unit.get_parent()
	print("unit entered: ", unit, " id: ", unit_id, " unit_node: ", unit.get_parent().name)
	debug_units_visible()

func unit_exited(unit:Node3D) -> void:
	var unit_id:int = unit.get_instance_id()
	if !BoxSelectionUnits_Visible.keys().has(unit_id):return
	BoxSelectionUnits_Visible.erase(unit_id)
	print("unit exited: ", unit, " id: ", unit_id, " unit_node: ", unit.get_parent())

func debug_units_visible() -> void:
	print(BoxSelectionUnits_Visible)

func initialize_interface() -> void:
	ui_drag_box.visible = false
	player_camera_visibleunits_Area3D.body_entered.connect(unit_entered)
	player_camera_visibleunits_Area3D.body_exited.connect(unit_exited)

func _input(event:InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_leftclick"):
		drag_rectangle_area.size = Vector2(0,0)
		drag_rectangle_area.position = get_global_mouse_position()
		ui_drag_box.position = drag_rectangle_area.position
		mouse_left_click = true
		ui_drag_box.visible = true
	if Input.is_action_just_released("mouse_leftclick"):
		mouse_left_click = false
		ui_drag_box.visible = false
		cast_selection()

# Actually select units
func cast_selection() -> void:
	for unit in BoxSelectionUnits_Visible.values():
		if drag_rectangle_area.abs().has_point( player_camera.get_Vector2_from_Vector3(unit.transform.origin) ):
			if unit.has_method("selected"):
				unit.selected()
		else:
			if unit.has_method("deselect"):
				unit.deselect()
	
func _process(delta:float) -> void:
	if mouse_left_click:
		if !ui_drag_box.visible:
			if drag_rectangle_area.size.length_squared() > min_drag_squared:
				ui_drag_box.visible = true
		
		else:
			update_ui_dragbox()
		
		drag_rectangle_area.size = get_global_mouse_position() - drag_rectangle_area.position

func update_ui_dragbox() -> void:
	ui_drag_box.size = abs(drag_rectangle_area.size)
	# Detect when to scale backwards so the selection dragbox can go right to left
	# Detect X swap
	if drag_rectangle_area.size.x < 0:
		ui_drag_box.scale.x = -1
	else:
		ui_drag_box.scale.x = 1
	# Detect Y swap
	if drag_rectangle_area.size.y < 0:
		ui_drag_box.scale.y = -1
	else:
		ui_drag_box.scale.y = 1
