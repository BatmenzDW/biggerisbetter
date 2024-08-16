class_name Drill

extends Building

func _clock() -> void:
	Game.score.emit(1)
