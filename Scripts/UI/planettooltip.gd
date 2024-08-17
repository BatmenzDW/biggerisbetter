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
		ui.get_node("Planet Label").visible = true
		ui.get_node("Planet Label").global_position = get_parent().position
		
	pass


func _on_mouse_entered():
	shouldtooltip = true
	pass # Replace with function body.


func _on_mouse_exited():
	if ui:
		ui.get_node("Planet Label").visible = false
	pass # Replace with function body.
