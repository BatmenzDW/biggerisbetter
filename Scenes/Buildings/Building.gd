extends Area2D

class_name Building

var is_active: bool = true

const SNAP: Vector2 = Vector2(32, 32)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if is_active:
			var new_postion = get_viewport().get_mouse_position()
			global_position = snapped(new_postion, SNAP)


func place() -> void:
	is_active = false

func _ready() -> void:
	Game.clock.connect(_clock)

func _clock() -> void:
	pass
