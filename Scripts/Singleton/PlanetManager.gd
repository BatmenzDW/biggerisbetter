extends Node

var loadedPlanets : Array[Orbitable] = []

func load_planets(planets:Array[Orbitable])->void:
	loadedPlanets.append_array(planets)

func load_planet(planet: Orbitable)->void:
	loadedPlanets.append(planet)

func unload_planets(planets:Array[Orbitable])->void:
	for p in planets:
		loadedPlanets.erase(p)
		p.queue_free()

func unload_all()->void:
	loadedPlanets = []

func unload_planet(planet: Orbitable)->void:
	loadedPlanets.erase(planet)
	planet.queue_free()

func get_total_population()->int:
	var total = 0
	for p in loadedPlanets:
		if not is_instance_valid(p):
			continue
		if p.planetPopulation > 0:
			total += p.planetPopulation
	return total
