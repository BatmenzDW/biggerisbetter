extends Node2D

var shouldtooltip = false # Whether or not to show a tooltip
var tooltipoffset: Vector2 = Vector2(10, 0)

@onready var planet: Orbitable = $".."

@onready var ui: Control = planet.ui # gets Reference to UI

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if shouldtooltip && ui:
		shouldtooltip = false
		var pl = ui.get_node("Planet Label")
		
		pl.get_node("Name").text = planet.planetName
		pl.get_node("Health").text = "Health: " + str(planet.planetHealth)
		
		if(planet.planetPopulation < 0):
			pl.get_node("Population").text = "Inhabitable"
		else:
			pl.get_node("Population").text = "Population: " + str(planet.planetPopulation)
		
		pl.visible = true
		pl.global_position = planet.position
		
		
	if ui:
		if ui.has_node("Planet Label"):
			if ui.get_node("Planet Label").visible:
				ui.get_node("Planet Label").global_position = get_global_mouse_position() + tooltipoffset
	pass


func _on_mouse_entered():
	shouldtooltip = true
	pass # Replace with function body.


func _on_mouse_exited():
	if ui:
		ui.get_node("Planet Label").visible = false
	pass # Replace with function body.
