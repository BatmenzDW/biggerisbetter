class_name Drill

extends Building

var itemA_pre = preload("res://Scenes/Item.tscn")

func _clock() -> void:
	Game.score.emit(1)
