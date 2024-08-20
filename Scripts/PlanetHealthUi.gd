extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(get_parent().get_node("SolarSystemGenerator").numplanet )
	#$GridContainer.columns = get_parent().get_node("SolarSystemGenerator").numplanet
	#print($GridContainer.columns)
	for i in range (1,get_parent().get_parent().get_node("SolarSystem").get_child_count()):
		$GridContainer.get_child(i).PROCESS_MODE_INHERIT
		$GridContainer.get_child(i).visible = true
		
		#print(get_parent().get_node("SolarSystem").get_child(i).planetName)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#for x in range (1, $GridContainer.get_child_count())
		#$GridContainer.get_child(i).visible
	pass
