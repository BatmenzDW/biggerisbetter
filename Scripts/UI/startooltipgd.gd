extends Node2D

var shouldtooltip = false # Whether or not to show a tooltip
var updatetooltip = false

var tooltipoffset: Vector2 = Vector2(10, 0)

@onready var star: Star = $".."

@onready var ui: Control = star.ui # gets Reference to UI

func destroy():
	var pl
	if ui:
		if !pl and ui.has_node("Planet Label"):
			pl = ui.get_node("Planet Label")
			
	if updatetooltip:
		pl.visible = false
		
	## TODO: Find if upgrade menu is open for this specific planet

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var pl
	if ui:
		if ui.has_node("Star Label"):
			pl = ui.get_node("Star Label")
	
	if shouldtooltip and ui and pl:
		shouldtooltip = false
		
		pl.get_node("Name").text = star.starName
		
		updatetooltip = true
		
		pl.visible = true
		pl.global_position = star.position
		
	if updatetooltip:
		pl.get_node("Name").text = star.starName
	if pl:
		if pl.visible:
			pl.global_position = get_global_mouse_position() + tooltipoffset
			

func _on_mouse_entered():
	shouldtooltip = true
	pass # Replace with function body.


func _on_mouse_exited():
	if updatetooltip:
		updatetooltip = false
		
	if ui:
		ui.get_node("Star Label").visible = false
	pass # Replace with function body.
