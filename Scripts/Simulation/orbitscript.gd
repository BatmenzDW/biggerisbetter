extends Node2D

class_name Orbitable

@onready var planet_scroll: PlanetScroll = $PlanetScroll
@onready var collider: CollisionShape2D = $CollisionShape2D
#@onready var collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var population_growth_timer: Timer = $"Population Growth"

@export var planetName := "Planet X"
@export var planetHealth := 100
@export var planetPopulation := 100 # -1 for inhabitable

@export var orbiting : Orbitable # Planet that this planet is orbiting. None for static

@export var oribalPeriod := 0.1 # How fast planet orbits

@export var orbitalRadius := 500 # How far from planet to orbit

@export var orbitDelta := 0.0 # How far planet is into a full orbit 0-1

@export var mass := 1.0 # Mass of planet. Unit: Mass of Earth

@export var ui : Control
var growth = 1 #for upgrade to increase population growth

var gravity := 10000000.0 # Needs to be pretty big

var asteroidfield : Node2D # Reference to asteroid field

var buildings : Array[Building] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get reference to asteroid field if it exists
	if has_node("../AsteroidField"):
		asteroidfield = get_node("../AsteroidField")
	population_growth_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	
	# Handle orbit
	if orbiting: 
		orbitDelta += delta * oribalPeriod
		orbitDelta = wrapf(orbitDelta, 0, 1)
		
		position.x = orbiting.position.x + (cos(orbitDelta * TAU) * orbitalRadius)
		position.y = orbiting.position.y + sin(orbitDelta * TAU) * (orbitalRadius)
		
	# Gravity on Asteroids 
	#if asteroidfield:
		## Get all asteroids
		#for x in asteroidfield.get_children():
			#if x is Asteroid:
				#
				## Get the force using the gravity formula
				#var f = (gravity * mass * x.earthmass) / x.position.distance_squared_to(position)
				#
				## Apply force in the direction of the planet
				#x.apply_central_force(f * x.position.direction_to(position))

func get_size() -> Vector2:
	return planet_scroll.sprwidth * scale

func get_radius() -> float:
	return collider.shape.radius * scale.x
	
func take_damage():
	planetHealth -= 10 
	planetPopulation = planetPopulation -  (.1 * planetPopulation)
	if(planetHealth <= 0 ):
		planetPopulation = 0;
		#queue_free()


func _on_population_growth_timeout() -> void:
	planetPopulation = planetPopulation + ((.1 * growth) * planetPopulation) 


func _on_area_2d_body_entered(body: RigidBody2D) -> void:
	#print(body)
	#body.noPull = false
	var force = (gravity * mass * body.earthmass) / body.position.distance_squared_to(position)
	#print(force)
	#print("pull")
	body.apply_central_force(force * body.position.direction_to(position))
