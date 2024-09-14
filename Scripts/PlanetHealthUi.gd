extends Control
@onready var SolarSytemNode = get_parent().get_parent().get_node("SolarSystem")
const BALLMASK = preload("res://Assets/vinny-approval-awaiting/ballmask.png")
@onready var HealthUiButton = preload("res://Scripts/UI/HealthUIButton.gd")

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
		var child1 = ProgressBar.new()
		var child2 = Button.new()
		$GridContainer.add_child(parent) 
		parent.add_child(child1)
		child1.max_value = SolarSytemNode.get_child(i).maxHealth
		parent.custom_minimum_size = Vector2(45,45)
		child1.scale = Vector2(0.5,0.5)
		child1.size = Vector2(90,27)
		child1.position = Vector2(0,33)
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.7, 0.0, 0.02)
		child1.add_theme_stylebox_override("fill", style)
		
		
		#child2.size = Vector2(45,45)
		child2.scale = Vector2(.33,.33)
		child2.clip_children = CanvasItem.CLIP_CHILDREN_ONLY
		child2.icon = BALLMASK
		child2.set_script(HealthUiButton)
		child2.planetID = i
		parent.add_child(child2)
		#child2.icon =  SolarSytemNode.get_child(i).get_child(2).spr2.texture
		var child2a = Sprite2D.new()
		child2.add_child(child2a)
		child2a.texture = SolarSytemNode.get_child(i).get_child(2).spr2.texture
		child2a.scale = Vector2(1,2.7)
		

	
