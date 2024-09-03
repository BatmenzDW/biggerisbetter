extends Button

var planetID 
var upgrade
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.connect("pressed", _on_pressed)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed():
	
	upgrade = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SolarSystem").get_child(planetID).ui.get_node("Upgrade_UI")
	if(upgrade.visible != true):
				upgrade.open()
				#upgrade.visible = true
				upgrade.global_position = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Camera2D").position - Vector2(288,156)
				upgrade.nplanet(get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SolarSystem").get_child(planetID))
	else:
		upgrade._on_close_pressed()
		upgrade = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SolarSystem").get_child(planetID).ui.get_node("Upgrade_UI")
		upgrade.open()
				#upgrade.visible = true
		upgrade.global_position = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Camera2D").position - Vector2(288,156)
		upgrade.nplanet(get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SolarSystem").get_child(planetID))
				
	
				
func _on_mouse_entered():
	Game.overlap +=1
	#if(get_parent().get_parent().get_parent().get_parent().get_node("BuildingUI").buildindex != 0 ):
	get_parent().get_parent().get_parent().get_parent().get_node("BuildingUI").previndex = get_parent().get_parent().get_parent().get_parent().get_node("BuildingUI").buildindex
	
	get_parent().get_parent().get_parent().get_parent().get_node("BuildingUI")._on_item_list_item_selected(0)

func _on_mouse_exited():
	
	Game.overlap -= 1
	if(get_parent().get_parent().get_parent().get_parent().get_parent().get_node("UI").get_node("Upgrade_UI").visible == false && get_tree().paused == false):
		get_parent().get_parent().get_parent().get_parent().get_node("BuildingUI")._on_item_list_item_selected(get_parent().get_parent().get_parent().get_parent().get_node("BuildingUI").previndex)
		
