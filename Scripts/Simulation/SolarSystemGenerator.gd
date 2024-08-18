extends Node
class_name SolarSystemGenerator

@export var star : Star
@export var solar_system : Node2D

#@onready var starnames = preload("res://Resources/NameGen/starnames.tres")
#@onready var planetnames = preload("res://Resources/NameGen/planetnames.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func generate_system():
	if !star || !solar_system:
		print("no star and/or solar system")
		return
	
	#var starname = starnames.text[randi_range(0, len(starnames.text))]
	
	#star.starName = starname
		
	pass
