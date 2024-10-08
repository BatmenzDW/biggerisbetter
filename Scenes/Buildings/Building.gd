extends Area2D

class_name Building

@onready var collider: CollisionShape2D = $Collider

@onready var sprite: Sprite2D = $Sprite
@onready var button: Button = $Button

@export var buildingName := "Drill"
@export var buildingHealth := 100
@export var description: String

@export var upgrades : Array[BuildingUpgradeCostResource] = []
@onready var upgrade_ui: BuildingUpgradeUI = $Upgrade_UI


var orbiting : Orbitable # Planet that this is orbiting. None for static
var nearestOrbit : Orbitable

@export var oribalPeriod := -0.25 # How fast it orbits

var orbitalRadius : float = 0.0 # How far from planet to orbit

var orbitDelta := 0.0 # How far it is into a full orbit 0-TAU

@export var mass := 1.0

@export var buildingLevel := 1

@export var buildCost : int

@export_category("Production")

@export var productionCost : ProdCostResource

@export var ui : Control

var is_placing: bool = true

var contents: Array[Item] = []

var tooltip := ""

var clock_cycles = 0
var max_cycles = 1

#const SNAP: Vector2 = Vector2(32, 32)
const EPSILON = 0.5
const MAX_FLOAT = 1.79769e308
const tooltipoffset: Vector2 = Vector2(10, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_placing:
		_update_placing_position()
	else:
		if ui:
			var panel = (ui.get_node("LabelContainer") as Control)
			if panel:
				if panel.visible:
					panel.global_position = get_global_mouse_position() + tooltipoffset

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
			_update_placing_position()

func _update_placing_position() -> void:
	var new_position = get_global_mouse_position()
	var next_position = get_nearest_placement(new_position)
	if next_position == null:
		return
	global_position = next_position
	look_at(nearestOrbit.global_position)
	_check_placement()

func place() -> bool:
	#print("Placing " + buildingName)
	if _check_placement() and Game.overlap == 0:
		if Game.spend_funds(buildCost):
			is_placing = false
			orbiting = nearestOrbit
			get_parent().remove_child(self)
			orbiting.add_child(self)
			scale = Vector2(1/orbiting.scale.x, 1/orbiting.scale.y)		# counter-scale to keep size
		
			Game.clock.connect(_clock)
			res_inc(1)
			return true
		else:
			print("Can't afford")
			return false
	else:
		print("Can't build due to overlap.")
		return false

func res_inc(lvl: int):
	match self.buildingName:
		"Drill":
			match lvl:
				1:
					Game.oil += 15
					Game.crystal -= 1
				2:	
					Game.oil += 20
					Game.metal -= 5
					Game.crystal -= 4
					Game.fund -= 25
				3:
					Game.oil +=  40
					Game.metal -= 5
					Game.crystal -=5
					Game.fund -=45
					
		"Metal Mine":
			match lvl:
				1:
					Game.metal += 15
					Game.crystal -= 1
				2:	
					Game.metal += 20
					Game.crystal -= 4
					Game.oil -= 5
					Game.fund -= 25
				3:
					Game.metal +=  40
					Game.oil -= 5
					Game.crystal -=5
					Game.fund -= 45
			
		"Crystal Mine":
			match lvl:
				1:
					Game.oil -= 5
					Game.metal -= 5
					Game.crystal += 10
				2:	
					Game.oil -= 5
					Game.metal -= 5
					Game.fund -=25
					Game.crystal += 15
				3:
					Game.oil -= 5
					Game.metal -= 5
					Game.crystal += 25
					Game.fund -= 45
			
		"Factory":
			match lvl:
				1:
					Game.oil -= 3
					Game.metal -=3
					Game.crystal -= 4
					Game.fund += 100	
				2:	
					Game.oil -= 2
					Game.metal -= 2
					Game.crystal -= 2
					Game.fund += 1150	
				3:
					Game.oil -= 5
					Game.metal -= 5 
					Game.crystal -= 5
					Game.fund += 3850
				
	Game._update_score()

func res_dec(lvl:int):
	match self.buildingName:
		"Drill":
			match lvl:
				1:
					Game.oil -= 15
					Game.crystal += 1
				2:	
					Game.oil -= 35
					Game.metal += 5
					Game.crystal += 5
					Game.fund +=25
				3:
					Game.oil -=  75
					Game.metal += 10
					Game.crystal += 10
					Game.fund += 70
					
		"Metal Mine":
			match lvl:
				1:
					Game.metal -= 15
					Game.crystal += 1
				2:	
					Game.oil += 5
					Game.metal -= 35
					Game.crystal += 5
					Game.fund += 25
				3:
					Game.metal -= 75
					Game.oil += 10
					Game.fund += 70
					Game.crystal += 10
			
		"Crystal Mine":
			match lvl:
				1:
					Game.oil += 5
					Game.metal += 5
					Game.crystal -= 10
				2:	
					Game.oil += 10
					Game.metal += 10
					Game.crystal -= 25
					Game.fund += 25
				3:
					Game.oil += 15
					Game.metal += 15
					Game.crystal -= 50
					Game.fund += 70
			
		"Factory":
			match lvl:
				1:
					Game.oil += 3
					Game.metal += 3
					Game.crystal += 4
					Game.fund -= 100	
				2:	
					Game.oil += 5
					Game.metal += 5
					Game.crystal += 6
					Game.fund -= 1250	
				3:
					Game.oil += 10
					Game.metal +=10
					Game.crystal += 11
					Game.fund -= 5000		
	Game._update_score()
	
			
func remove(refund:bool=true) -> void:
	if refund:
		res_dec(self.buildingLevel)
		#print(self.buildingLevel)
		_refund()
	get_parent().remove_child(self)
	queue_free()

func _ready() -> void:
	SignalBus.building_upgrades_opened.connect(_on_other_clicked)
	
	ui = get_tree().root.get_node("SolarSystem/UI")
	tooltip = _make_tooltip()
	#print(button.tooltip_text)
	
	# debug
	#if get_tree().root.get_node("Building") == self:
		#is_placing = false
		#return
	
	if is_placing:
		var new_position = get_global_mouse_position()
		var next_position = get_nearest_placement(new_position)
		if next_position == null:
			return
		look_at(nearestOrbit.global_position)
		_check_placement()

func _update_tooltip() -> void:
	tooltip = _make_tooltip()
	if ui:
		(ui.get_node("LabelContainer/MarginContainer/Label") as Label).text = tooltip

func _make_tooltip() -> String:
	var tt = buildingName + " lvl" + str(buildingLevel) + "\n" +\
		description + "\n\n" +\
		"Production Cost: \n"
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
	if orbiting:
		Game.produce_resources(productionCost, orbiting.planetPopulation)

func _check_placement() -> bool:
	if len(get_overlapping_areas()) == 0 and nearestOrbit != null:
		sprite.modulate = Color.WHITE
		return true
	sprite.modulate = Color.RED
	return false

func update() -> void:
	pass

func has_space(_item: Item) -> bool:
	return false

func recieve_item(_item: Item) -> void:
	pass

func has_contents() -> bool:
	return false

func get_nearest_placement(point: Vector2):
	var min_dist = MAX_FLOAT
	var closest = null
	
	for p in PlanetManager.loadedPlanets:
		# math to get nearest point on planet
		if(p != null):
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

func upgrade(data:BuildingUpgradeCostResource) -> bool:
	if not Game.purchase_upgrade(data):
		return false
	res_inc(data.level)
	buildingLevel = data.level
	sprite.texture = data.new_texture
	productionCost = data.prodCost
	
	oilCost += data.oil
	metalCost += data.metal
	crystalCost += data.crystal
	fundsCost += data.funds
	
	_update_tooltip()
	
	return true


func _on_other_clicked(other:Building) -> void:
	
	if other != self:
		if(upgrade_ui.is_open):
			Game.overlap -= 1 
			upgrade_ui.close_quiet()

func _on_clicked() -> void:
	if not is_placing:
		SignalBus.building_upgrades_opened.emit(self)
		upgrade_ui.rotation = TAU - global_rotation
		upgrade_ui.open()

var oilCost = 0
var metalCost = 0
var crystalCost = 0
var fundsCost = 0

func _refund() -> void:
	Game.recieve_oil(oilCost/2)
	Game.recieve_metal(metalCost/2)
	Game.recieve_crystal(crystalCost/2)
	Game.recieve_funds((buildCost + fundsCost)/2)

func sell() -> void:
	remove()

var show_tooltip := false

func _on_mouse_entered() -> void:
	
	if !is_placing:
		self.get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").previndex = self.get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").buildindex
		self.get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI")._on_item_list_item_selected(0)
		
		show_tooltip = true
		#print("entered " + buildingName)
		if ui:
			(ui.get_node("LabelContainer/MarginContainer/Label") as Label).text = tooltip
			(ui.get_node("LabelContainer") as Control).show()


func _on_mouse_exited() -> void:
	show_tooltip = false
	if !is_placing:
		if(get_node("Upgrade_UI").visible == false):
			self.get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI")._on_item_list_item_selected(self.get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").previndex)
	#print("exited " + buildingName)
	if ui:
		(ui.get_node("LabelContainer") as Control).hide()
