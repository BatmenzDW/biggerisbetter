extends Node2D

var shouldtooltip = false # Whether or not to show a tooltip
var tooltipoffset: Vector2 

var ui : Control # Reference to UI

# Called when the node enters the scene tree for the first time.
func _ready():
	ui = get_node("../../UI")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if shouldtooltip && ui:
		shouldtooltip = false
		var pl = ui.get_node("Planet Label")
		
		pl.get_node("Name").text = get_parent().planetName
		pl.get_node("Health").text = "Health: " + str(get_parent().planetHealth)
		
		if(get_parent().planetPopulation < 0):
			pl.get_node("Population").text = "Inhabitable"
		else:
			pl.get_node("Population").text = "Population: " + str(get_parent().planetPopulation)
		
		pl.visible = true
		pl.global_position = get_parent().position
		
	pass


func _on_mouse_entered():
	shouldtooltip = true
	pass # Replace with function body.


func _on_mouse_exited():
	if ui:
		ui.get_node("Planet Label").visible = false
	pass # Replace with function body.
