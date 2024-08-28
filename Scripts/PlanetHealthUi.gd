extends Control
@onready var SolarSytemNode = get_parent().get_parent().get_node("SolarSystem")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_parent().get_parent().get_node("SolarSystemGenerator").numplanet )
	#$GridContainer.columns = get_parent().get_node("SolarSystemGenerator").numplanet
	#print($GridContainer.columns)
	#print(get_parent().get_parent().get_node("SolarSystem").get_child_count())

	for i in range (0,get_parent().get_parent().get_node("SolarSystemGenerator").numplanet ):
		
		var parent = Panel.new()
		var child = ProgressBar.new()
		$GridContainer.add_child(parent) 
		parent.add_child(child)
		child.max_value = SolarSytemNode.get_child(i).maxHealth
		parent.custom_minimum_size = Vector2(45,45)
		child.scale = Vector2(0.5,0.5)
		child.size = Vector2(90,27)
		child.position = Vector2(0,33)
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.7, 0.0, 0.02)
		child.add_theme_stylebox_override("fill", style)
		#print(get_parent().get_parent().get_node("SolarSystem").get_child(i).planetName)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print($GridContainer.get_child_count())
	for x in range (0, $GridContainer.get_child_count()):
		$GridContainer.get_child(x).get_child(0).value = SolarSytemNode.get_child(x).planetHealth
	
