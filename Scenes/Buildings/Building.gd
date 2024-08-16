extends Area2D

class_name Building

var is_placing: bool = true

const SNAP: Vector2 = Vector2(32, 32)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if is_placing:
			var new_postion = get_viewport().get_mouse_position()
			global_position = snapped(new_postion, SNAP)


func place() -> void:
	is_placing = false
	Game.clock.connect(_clock)

func _ready() -> void:
	pass

func _clock() -> void:
	pass
