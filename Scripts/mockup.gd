extends Node2D

@onready var drill: Drill = $Drill

#func _ready() -> void:
	#get_tree().paused = true
#
#func _input(event: InputEvent) -> void:
	##if event.is_action_pressed("ui_accept"):
		##get_tree().paused = false
	#if event is InputEventMouseButton:
		#is_placeable = false
	#elif event is InputEventMouseMotion:
		#if is_placeable:
			#var new_postion = get_viewport().get_mouse_position()
			#placeable.global_position = snapped(new_postion, SNAP)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		drill.show()
		drill.is_active = true
