extends Node
class_name SolarSystemGenerator

@export var star : Star
@export var solar_system : Node2D

@onready var planetprefab = preload("res://Scenes/Prefabs/planetoid.tscn")

@onready var starnames = preload("res://Resources/NameGen/starnames.tres")
@onready var planetnames = preload("res://Resources/NameGen/planetnames.tres")

@export var planetdistance = 200

@export var planetscale = 0.5
@export var moonscale = 0.25
var numplanet
var nummoon = 0

@export_range (1, 3) var size: int

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_system()

func generate_system():
	if not star or not solar_system:
		print("no star and/or solar system")
		return
	
	var usednames = []
	
	var starname = starnames.text[randi_range(0, len(starnames.text ) - 1)]
	
	star.starName = starname
	
	var planetmin = 4
	var planetmax = 5
	
	match size:
		1:
			planetmin = 4
			planetmax = 5
		2:
			planetmin = 6
			planetmax = 8
		3:
			planetmin = 9
			planetmax = 12
			
	var planetct = randi_range(planetmin, planetmax)
	
	
	for i in range(planetct):
		var newplan = planetprefab.instantiate()
		newplan.orbiting = star
		newplan.ui = star.ui
		newplan.scale *= planetscale
		
		var pnameidx = randi_range(0, len(planetnames.text)-1)
		#while not usednames.has(pnameidx):
		#	pnameidx = randi_range(0, len(planetnames.text)-1)
		
		#usednames.push_back(pnameidx)
		
		newplan.planetName = planetnames.text[pnameidx]
		
		newplan.orbitDelta = randf()
		newplan.orbitalRadius = (i + 1) * planetdistance
		
		#newplan.orbitalPeriod = 0.1 * (planetct/(i+1))
		newplan.orbitalPeriod = 0.01 * (planetct/(i+1))
		
		solar_system.add_child(newplan)
		
		var moonroll = randi_range(1,3)
		if moonroll == 3:
			var newmoon = planetprefab.instantiate()
			nummoon+=1
			newmoon.orbiting = newplan
			newmoon.ui = newplan.ui
			newmoon.scale *= moonscale
			var mnameidx = randi_range(0, len(planetnames.text)-1)
		
			newmoon.planetName = planetnames.text[mnameidx]
		
			newmoon.orbitDelta = randf()
			newmoon.orbitalRadius = 100
			newmoon.orbitalPeriod = 0.3
			
			newmoon.mass = 0.4
			newmoon.planetHealth = 50
			newmoon.maxHealth = 50
			newmoon.planetPopulation = -1
			
			if newmoon.has_node("Line2D"):
				newmoon.get_node("Line2D").visible = false
			
			solar_system.add_child(newmoon)
		
		
		pass
	set_numplanet(planetct, nummoon)
	pass

func set_numplanet(plan,moon):
	numplanet = plan + moon
