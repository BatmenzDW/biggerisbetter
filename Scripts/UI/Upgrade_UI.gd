extends Control

var planet
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false;
	
	
	

func open():
	visible = true;

func close():
	visible = false
	


func _on_button_pressed() -> void:
	visible = false;
	


func _on_buy_1_pressed() -> void:
	planet.gain_health()
	
func nplanet(body):
	planet = body
	


func _on_buy_2_pressed() -> void:
	planet.growth += 1 


func _on_buy_3_pressed() -> void:
	planet.damage -= (.2 * planet.damage)
	
