extends Node3D


func _ready():
	deselect()


func selected() -> void:
	$selected.visible = true


func deselect() -> void:
	$selected.visible = false
