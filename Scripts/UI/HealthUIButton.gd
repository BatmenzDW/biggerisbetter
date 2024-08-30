extends Button

var planetID 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", _on_pressed)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed():
	var upgrade = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SolarSystem").get_child(planetID).ui.get_node("Upgrade_UI")
	if(upgrade.visible != true):
				upgrade.open()
				upgrade.visible = true
				upgrade.global_position = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Camera2D").position - Vector2(288,156)
				upgrade.nplanet(get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SolarSystem").get_child(planetID))
