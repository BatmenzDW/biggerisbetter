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
	

func nplanet(body):
	planet = body
	

func _on_buy_1_pressed() -> void:
	
	if (Game._metal >= 2000 && Game._funds >=15000):
		Game.spend_funds(15000)
		Game.spend_metal(2000)
		planet.gain_health(20)
	else:
		print("Not enough resources")
	


func _on_buy_2_pressed() -> void:
	if (Game._oil >= 1000 && Game._funds >=25000 && Game._crystal >= 200):
		Game.spend_funds(25000)
		Game.spend_oil(1000)
		Game.spend_crystal(200)
		planet.growth += 1 
	else:
		print("Not enough resources")
	


func _on_buy_3_pressed() -> void:
	
	if (Game._oil >= 10000 && Game._funds >=50000 && Game._metal >= 20000 && Game._crystal >= 250):
		Game.spend_funds(50000)
		Game.spend_oil(10000)
		Game.spend_metal(20000)
		Game.spend_crystal(250)
		planet.damage -= (.2 * planet.damage)
	else:
		print("Not enough resources")
	
