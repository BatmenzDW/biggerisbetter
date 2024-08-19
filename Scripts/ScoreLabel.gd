extends Label

func _ready() -> void:
	Game.update_score.connect(update)

func update() -> void:
	text = "Oil : " + str(Game.get_oil()) + "\n" +\
			"Metal : " + str(Game.get_metal()) + "\n" +\
			"Crystal : " + str(Game.get_crystal()) + "\n" +\
			"Funds : " + str(Game.get_funds()) + "\n" +\
			"Total Population: " + str(PlanetManager.get_total_population())
	
