extends Node2D

class_name Orbitable

@onready var planet_scroll: PlanetScroll = $PlanetScroll
@onready var collider: CollisionShape2D = $CollisionShape2D
#@onready var collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var population_growth_timer: Timer = $"Population Growth"
const UPGRADE_UI = preload("res://Scenes/Upgrade_UI.tscn")
@export var planetName := "Planet X"
@export var planetHealth := 100
@export var planetPopulation := 100 # -1 for inhabitable
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var orbiting : Node2D # Planet or star that this planet is orbiting. None for static

@export var orbitalPeriod := 0.1 # How fast planet orbits

@export var orbitalRadius := 500 # How far from planet to orbit

@export var orbitDelta := 0.0 # How far planet is into a full orbit 0-1

@export var mass := 1.0 # Mass of planet. Unit: Mass of Earth

@export var ui : Control

var growth = 1 #for upgrade to increase population growth

var gravity := 150000.0 # Needs to be pretty big

var asteroidfield : Node2D # Reference to asteroid field

var buildings : Array[Building] = []

var damage = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().has_node("Asteroid Field"):
		asteroidfield = get_parent().get_node("Asteroid Field")
	elif get_parent().get_parent().has_node("Asteroid Field"):
		asteroidfield = get_parent().get_parent().get_node("Asteroid Field")
		
	PlanetManager.load_planet(self)
	# Get reference to asteroid field if it exists
	population_growth_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	
	# Handle orbit
	if orbiting: 
		orbitDelta += delta * orbitalPeriod
		orbitDelta = wrapf(orbitDelta, 0, 1)
		if(orbiting == null):#if centre planet dies before moon, mooon also dies
			$ToolTipHandler.destroy()
			queue_free()
		else: 
			position.x = orbiting.position.x + (cos(orbitDelta * TAU) * orbitalRadius)
			position.y = orbiting.position.y + sin(orbitDelta * TAU) * (orbitalRadius)
		
		
		
	# Gravity on Asteroids 
	if asteroidfield:
		## Get all asteroids
		for x in asteroidfield.get_children():
			if x is Asteroid:
				# Get the force using the gravity formula
				var f = (gravity * mass * x.earthmass) / x.position.distance_squared_to(position)
				
				# Apply force in the direction of the planet
				x.apply_central_force(f * x.position.direction_to(position))

func get_size() -> Vector2:
	return planet_scroll.sprwidth * scale

func get_radius() -> float:
	return collider.shape.radius * scale.x
	
func take_damage():
	planetHealth -= damage
	audio_stream_player_2d.play()
	if planetPopulation >= 0:
		planetPopulation *= 0.9
	
	if(planetHealth <= 0 ):
		planetPopulation = -1;
		PlanetManager.unload_planet(self)
		$ToolTipHandler.destroy()
		
		
func gain_health(i = 20):
	planetHealth += i 
	if(planetHealth >= 100 ):
		planetHealth = 100;
	print("gained")


func _on_population_growth_timeout() -> void:
	planetPopulation += ((.1 * growth) * planetPopulation) 


#func _on_area_2d_body_entered(body: RigidBody2D) -> void:
#	#print(body)
#	#body.noPull = false
#	var force = (gravity * mass * body.earthmass) / body.position.distance_squared_to(position)
#	#print(force)
#	#print("pull")
#	body.apply_central_force(force * body.position.direction_to(position))


#func _on_button_pressed() -> void:
	#
	#var item = UPGRADE_UI.instantiate()
	#print(self)
	#item.nplanet(self)
	#add_child(item)
