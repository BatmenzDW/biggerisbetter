extends Label

func _ready() -> void:
	Game.update_score.connect(update)

func update() -> void:
	text = "Oil : " + str(Game.get_oil()) + " ( " +  str(Game.oil)+ "/s )\n" +\
			"Metal : " + str(Game.get_metal()) +  " ( " +  str(Game.metal)+ "/s )\n" +\
			"Crystal : " + str(Game.get_crystal()) + " ( " +  str(Game.crystal)+ "/s )\n" +\
			"Funds : " + str(Game.get_funds()) + " ( " +  str(Game.fund)+ "/s )\n" +\
			"Total Population: " + str(PlanetManager.get_total_population())
	
