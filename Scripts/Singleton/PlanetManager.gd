extends Node

var loadedPlanets : Array[Orbitable] = []

func load_planets(planets:Array[Orbitable])->void:
	loadedPlanets.append_array(planets)

func unload_planets(planets:Array[Orbitable])->void:
	for p in planets:
		loadedPlanets.erase(p)
