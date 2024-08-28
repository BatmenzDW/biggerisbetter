extends Control
@onready var SolarSytemNode = get_parent().get_parent().get_node("SolarSystem")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	init_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	for x in range (0, $GridContainer.get_child_count()):
		if(SolarSytemNode.get_child_count() < $GridContainer.get_child_count()):
			init_health()
			break
		$GridContainer.get_child(x).get_child(0).value = SolarSytemNode.get_child(x).planetHealth

func init_health():
	if($GridContainer.get_child_count()>0):
		for x in range (0, $GridContainer.get_child_count()):
			$GridContainer.get_child(x).queue_free()
	
	for i in range (0,SolarSytemNode.get_child_count()):
		
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
	
	
