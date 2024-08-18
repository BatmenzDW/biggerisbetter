extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_start_pressed() -> void:
	Game.start_game(self)


func _on_quit_pressed() -> void:
	get_tree().quit()
