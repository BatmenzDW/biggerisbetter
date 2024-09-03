extends Node2D

var shouldtooltip = false # Whether or not to show a tooltip
var mouseover = false # Whether or not the mouse is currently over the planet
var updatetooltip = false

var tooltipoffset: Vector2 = Vector2(10, 0)

@onready var planet: Orbitable = $".."

@onready var ui: Control = planet.ui # gets Reference to UI

func destroy():
	var pl = null
	var upgrade = null
	if ui:
		if !pl and ui.has_node("Planet Label"):
			pl = ui.get_node("Planet Label")
		if !upgrade and ui.has_node("Upgrade_UI"):
			upgrade = ui.get_node("Upgrade_UI")
			
	if updatetooltip:
		pl.visible = false
		
	## TODO: Find if upgrade menu is open for this specific planet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	var pl
	var upgrade
	if ui:
		if ui.has_node("Planet Label"):
			pl = ui.get_node("Planet Label")
		if ui.has_node("Upgrade_UI"):
			upgrade = ui.get_node("Upgrade_UI")
	
	if shouldtooltip and ui and pl:
		shouldtooltip = false
		
		pl.get_node("Name").text = planet.planetName
		pl.get_node("Health").text = "Health: " + str(planet.planetHealth)
		
		if(planet.planetPopulation < 0):
			pl.get_node("Population").text = "Inhabitable"
		else:
			pl.get_node("Population").text = "Population: " + str(int(planet.planetPopulation))
		
		updatetooltip = true
		
		pl.visible = true
		pl.global_position = planet.position
		
	if updatetooltip:
		pl.get_node("Name").text = planet.planetName
		pl.get_node("Health").text = "Health: " + str(planet.planetHealth)
		
		if(planet.planetPopulation < 0):
			pl.get_node("Population").text = "Inhabitable"
		else:
			pl.get_node("Population").text = "Population: " + str(int(planet.planetPopulation))
		
	
	if mouseover and Input.is_action_just_pressed("mouse_select"):
		if pl:
			pl.visible = false
		if upgrade:
			if(upgrade.visible != true):
				upgrade.open()
				upgrade.visible = true
				upgrade.global_position = get_parent().get_parent().get_parent().get_node("Camera2D").position - Vector2(288,156)
				upgrade.nplanet(planet)
		
	if pl:
		if pl.visible:
			pl.global_position = get_global_mouse_position() + tooltipoffset
			

func _on_mouse_entered():
	mouseover = true
	shouldtooltip = true
	if(get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").buildindex != 0):
		get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").previndex = get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").buildindex 
	get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI")._on_item_list_item_selected(0)
	Game.overlap += 1
	pass # Replace with function body.


func _on_mouse_exited():
	if(get_parent().get_parent().get_parent().get_node("UI").get_node("Upgrade_UI").visible == false):
		get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI")._on_item_list_item_selected(get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").previndex)
	Game.overlap -=1
	if mouseover:
		mouseover = false 
	
	if updatetooltip:
		updatetooltip = false
		
	if ui:
		ui.get_node("Planet Label").visible = false
	pass # Replace with function body.
