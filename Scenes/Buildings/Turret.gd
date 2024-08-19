extends Building

class_name Turret

@onready var fov: Area2D = $FieldOfView
@onready var emitter: Node2D = $LaserEmitter

const LASER = preload("res://Scenes/Prefabs/laser.tscn")

var laser: Line2D

@export var damage := 5.0
@export var crystal_cost := 1

func _clock() -> void:
	var targets = fov.get_overlapping_bodies()
	var min_dist = MAX_FLOAT
	var chosen_target: Asteroid
	
	for target in targets:
		if target is not Asteroid:
			continue
		target = target as Asteroid
		
		var dist = global_position.distance_to(target.global_position)
		
		if dist < min_dist:
			min_dist = dist
			chosen_target = target
	
	if chosen_target != null:
		_fire_at(chosen_target)

var laser_on_time := 0.0

func _fire_at(target: Asteroid):
	if laser_on_time > 0:
		return
	
	if Game.spend_crystal(crystal_cost):
		laser = LASER.instantiate()
		
		# get edge point
		var center = target.global_position
		var r = target.get_radius()
		var V = emitter.global_position - center
		var nearest = center + V / V.length() * r
		
		laser.set_point_position(0, emitter.global_position)
		laser.set_point_position(1, nearest)
		get_tree().root.add_child(laser)

		target.take_damage(damage)
		laser_on_time = 0.5

func _process(delta: float) -> void:
	super._process(delta)
	if laser_on_time > 0:
		laser_on_time -= delta
		if laser_on_time <= 0:
			get_tree().root.remove_child(laser)
			laser.queue_free()

func _make_tooltip() -> String:
	return buildingName + str(buildingLevel) + "\n\n" + \
		"Attack Cost: \n" +\
		"	Crystal: " + str(crystal_cost) + "\n" +\
		"Damage: " + str(damage)

func upgrade(data:BuildingUpgradeCostResource) -> bool:
	if not Game.purchase_upgrade(data):
		return false
	
	buildingLevel = data.level
	sprite.texture = data.new_texture
	
	crystal_cost = data.prodCost.crystal
	damage = data.damage
	
	oilCost += data.oil
	metalCost += data.metal
	crystalCost += data.crystal
	fundsCost += data.funds
	
	return true
