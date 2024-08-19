extends Node2D

class_name Level

@export var startingOil : int
@export var startingMetal : int
@export var startingCrystal : int
@export var startingFunds : int = 5000

var buildings_pre: Array[PackedScene] = [
	preload("res://Scenes/Buildings/drill.tscn"), 
	preload("res://Scenes/Buildings/MetalMine.tscn"), 
	preload("res://Scenes/Buildings/CrystalMine.tscn"),
	preload("res://Scenes/Buildings/Factory.tscn"),
	preload("res://Scenes/Buildings/Turret.tscn"),
	preload("res://Scenes/Buildings/Rocket.tscn"),
]
var land_pad_pre : PackedScene = preload("res://Scenes/Buildings/landing_pad.tscn")
var buildingIndex: int = 0

var building: Building

# testing
@onready var asteroid_spawner: Node2D = $"Asteroid Spawner"
@onready var asteroid_spawner_2: Node2D = $"Asteroid Spawner2"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_building"):
		if building == null:
			SignalBus.building_selected_input.emit(buildingIndex)
			_select_building(buildingIndex)
		else:
			if building is LandingPad:
				(building as LandingPad).parent.remove()
			SignalBus.building_deselected_input.emit()
			remove_child(building)
			building.queue_free()
	elif event.is_action_pressed("place_building"):
		if building != null:
			if building.place():
				if building is Rocket:
					var pad = land_pad_pre.instantiate()
					(building as Rocket).set_landing_pad(pad)
					building = pad
				else:
					building = buildings_pre[buildingIndex].instantiate()
				add_child(building)
	if (event.is_action_pressed("next_building") or event.is_action_pressed("previous_building")) and building is not LandingPad:
		if event.is_action_pressed("next_building"):
			buildingIndex += 1
			if buildingIndex >= len(buildings_pre):
				buildingIndex = 0
		elif event.is_action_pressed("previous_building"):
			buildingIndex -= 1
			if buildingIndex < 0:
				buildingIndex = len(buildings_pre) - 1
		SignalBus.building_selected_input.emit(buildingIndex)
		_select_building(buildingIndex)

func _ready() -> void:
	# testing
	asteroid_spawner.process_mode = Node.PROCESS_MODE_DISABLED
	asteroid_spawner_2.process_mode = Node.PROCESS_MODE_DISABLED
	
	SignalBus.building_selected_gui.connect(_select_building)
	Game.clock.connect(_clock)
	
	Game.set_oil(startingOil)
	Game.set_metal(startingMetal)
	Game.set_crystal(startingCrystal)
	Game.set_funds(startingFunds)

func _select_building(index: int):
	#print("selected: " + str(index))
	buildingIndex = index
	if building != null:
		remove_child(building)
		building.queue_free()
	building = buildings_pre[buildingIndex].instantiate()
	add_child(building)

func _clock()->void:
	var population = PlanetManager.get_total_population()
	if population <= 0:
		Game.game_over(self)
