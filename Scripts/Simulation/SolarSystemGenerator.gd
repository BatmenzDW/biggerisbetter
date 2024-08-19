extends Node
class_name SolarSystemGenerator

@export var star : Star
@export var solar_system : Node2D

@onready var planetprefab = preload("res://Scenes/Prefabs/planetoid.tscn")

@onready var starnames = preload("res://Resources/NameGen/starnames.tres")
@onready var planetnames = preload("res://Resources/NameGen/planetnames.tres")

@export var planetdistance = 150

@export var planetscale = 0.5

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
		newplan.orbitalPeriod = 0.025 * (planetct/(i+1))
		
		solar_system.add_child(newplan)
		
		pass
	
	pass
