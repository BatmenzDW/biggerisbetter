extends Area2D

class_name Building

@onready var collider: CollisionShape2D = $Collider

@onready var sprite: Sprite2D = $Sprite
@onready var tooltip: Control = $Tooltip

@export var buildingName := "Drill"
@export var buildingHealth := 100

var orbiting : Orbitable # Planet that this is orbiting. None for static
var nearestOrbit : Orbitable

@export var oribalPeriod := 0.1 # How fast it orbits

var orbitalRadius : float = 0.0 # How far from planet to orbit

var orbitDelta := 0.0 # How far it is into a full orbit 0-1

@export var mass := 1.0

@export var buildingLevel := 1

@export var buildCost : int

@export_category("Production")

@export var productionCost : ProdCostResource

var is_placing: bool = true

var contents: Array[Item] = []

var clock_cycles = 0
var max_cycles = 1

#const SNAP: Vector2 = Vector2(32, 32)
const EPSILON = 0.5
const MAX_FLOAT = 1.79769e308

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	
	# Handle orbit
	if orbiting: 
		orbitDelta += delta * oribalPeriod
		orbitDelta = wrapf(orbitDelta, 0, TAU)
		
		global_position.x = orbiting.global_position.x + (cos(orbitDelta) * orbitalRadius)
		global_position.y = orbiting.global_position.y + sin(orbitDelta) * (orbitalRadius)
		look_at(orbiting.global_position)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if is_placing:
			var new_postion = get_global_mouse_position()
			global_position = get_nearest_placement(new_postion)
			look_at(nearestOrbit.global_position)
			_check_placement()


func place() -> bool:
	#print("Placing " + buildingName)
	if _check_placement():
		if Game.spend_funds(buildCost):
			is_placing = false
			orbiting = nearestOrbit
			get_parent().remove_child(self)
			orbiting.add_child(self)
			scale = Vector2(1/orbiting.scale.x, 1/orbiting.scale.y)		# counter-scale to keep size
			Game.clock.connect(_clock)
			return true
		else:
			print("Can't afford")
			return false
	else:
		print("Can't build due to overlap.")
		return false

func _ready() -> void:
	tooltip.tooltip_text = _make_tooltip()
	print(tooltip.tooltip_text)
	
	# debug
	#if get_tree().root.get_node("Building") == self:
		#is_placing = false
		#return
	
	if is_placing:
		var new_postion = get_global_mouse_position()
		global_position = get_nearest_placement(new_postion)
		look_at(nearestOrbit.global_position)
		_check_placement()

func _make_tooltip() -> String:
	var tt = "Production Cost: \n"
	if productionCost.oil > 0:
		tt += "    Oil: " + str(productionCost.oil) + "\n"
	if productionCost.metal > 0:
		tt += "    Metal: " + str(productionCost.metal) + "\n"
	if productionCost.crystal > 0:
		tt += "    Crystal: " + str(productionCost.crystal) + "\n"
	if productionCost.funds > 0:
		tt += "    Funds: " + str(productionCost.funds) + "\n"
		
	if productionCost.minPopulation > 0:
		tt += "Requirements: \n    Min. Population: " + str(productionCost.minPopulation) + "\n"
	
	tt += "Output: \n"
	
	if productionCost.oil_output > 0:
		tt += "    Oil: " + str(productionCost.oil_output) + "\n"
	if productionCost.metal_output > 0:
		tt += "    Metal: " + str(productionCost.metal_output) + "\n"
	if productionCost.crystal_output > 0:
		tt += "    Crystal: " + str(productionCost.crystal_output) + "\n"
	if productionCost.funds_output > 0:
		tt += "    Funds: " + str(productionCost.funds_output) + "\n"
	
	return tt.trim_suffix("\n")

func _clock() -> void:
	Game.produce_resources(productionCost, 0)

func _check_placement() -> bool:
	if len(get_overlapping_areas()) == 0 and nearestOrbit != null:
		sprite.modulate = Color.WHITE
		return true
	sprite.modulate = Color.RED
	return false

func update() -> void:
	pass

func has_space(item: Item) -> bool:
	return false

func recieve_item(item: Item) -> void:
	pass

func has_contents() -> bool:
	return false

func get_nearest_placement(point: Vector2):
	var min_dist = MAX_FLOAT
	var closest = null
	
	for p in PlanetManager.loadedPlanets:
		# math to get nearest point on planet
		var center = p.global_position
		var r = p.get_radius() + get_size().y/2
		var V = point - center
		var nearest = center + V / V.length() * r
		var dist = (point - nearest).length()
		
		if dist < min_dist:
			min_dist = dist
			closest = nearest
			orbitalRadius = r
			nearestOrbit = p
			orbitDelta = center.angle_to_point(nearest)
	
	#print(closest)
	#print(min_dist)
	return closest

func get_size():
	return collider.shape.size
