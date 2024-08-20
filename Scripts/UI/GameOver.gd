extends CanvasLayer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.play()
	pass # Replace with function body.


func _on_restart_pressed() -> void:
	$GameOptions.visible = true
	$VBoxContainer/CenterContainer.visible = false

	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_game_pressed():
	Game.start_game(self, $GameOptions/SolarSystemSize.get_selected_id())
	pass # Replace with function body.


func _on_back_pressed():
	$GameOptions.visible = false
	$Main.visible = true
	pass # Replace with function body.
