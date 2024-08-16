extends Area2D

class_name Drill

var is_active: bool = false

const SNAP: Vector2 = Vector2(32, 32)

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		is_active = false
	elif event is InputEventMouseMotion:
		if is_active:
			var new_postion = get_viewport().get_mouse_position()
			global_position = snapped(new_postion, SNAP)

func _ready() -> void:
	hide()
