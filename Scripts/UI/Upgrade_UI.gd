extends Control

var planet
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true;
	
	
	

func open():
	self.visible = true;

func close():
	self.visible = false
	


func _on_button_pressed() -> void:
	self.visible = false;
	


func _on_buy_1_pressed() -> void:
	print(planet.name)
	planet.gain_health()
	
func nplanet(body):
	planet = body
	
