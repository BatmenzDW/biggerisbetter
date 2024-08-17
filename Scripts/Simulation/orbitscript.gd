extends Node2D

@export var orbiting : Node2D # Planet that this planet is orbiting. None for static

@export var oribalPeriod := 0.1 # How fast planet orbits

@export var orbitalRadius := 500 # How far from planet to orbit

@export var orbitDelta := 0.0 # How far planet is into a full orbit 0-1

@export var mass := 1.0 # Mass of planet. Unit: Mass of Earth

var gravity := 10000000.0 # Needs to be pretty big

var asteroidfield : Node2D # Reference to asteroid field

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get reference to asteroid field if it exists
	if has_node("../AsteroidField"):
		asteroidfield = get_node("../AsteroidField")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Handle orbit
	if orbiting: 
		orbitDelta += delta * oribalPeriod
		orbitDelta = wrapf(orbitDelta, 0, 1)
		
		position.x = orbiting.position.x + (cos(orbitDelta * TAU) * orbitalRadius)
		position.y = orbiting.position.y + sin(orbitDelta * TAU) * (orbitalRadius)
		
	# Gravity on Asteroids
	if asteroidfield:
		# Get all asteroids
		for x in asteroidfield.get_children():
			if x is Asteroid:
				
				# Get the force using the gravity formula
				var f = (gravity * mass * x.earthmass) / x.position.distance_squared_to(position)
				
				# Apply force in the direction of the planet
				x.apply_central_force(f * x.position.direction_to(position))
