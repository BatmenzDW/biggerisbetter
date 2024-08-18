extends Node2D

@onready var planets: Node = $Planets

@export var startingOil : int
@export var startingMetal : int
@export var startingCrystal : int
@export var startingFunds : int = 5000

var buildings_pre: Array[PackedScene] = [
	preload("res://Scenes/Buildings/drill.tscn"), 
	preload("res://Scenes/Buildings/MetalMine.tscn"), 
	preload("res://Scenes/Buildings/CrystalMine.tscn"),
	preload("res://Scenes/Buildings/Factory.tscn"),
]
var buildingIndex: int = 0

var building: Building

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_building"):
		if building == null:
			building = buildings_pre[buildingIndex].instantiate()
			add_child(building)
	elif event.is_action_pressed("place_building"):
		if building != null:
			if building.place():
				building = buildings_pre[buildingIndex].instantiate()
				add_child(building)
	if event.is_action_pressed("next_building") or event.is_action_pressed("previous_building"):
		if building != null:
			remove_child(building)
			building.queue_free()
		if event.is_action_pressed("next_building"):
			buildingIndex += 1
			if buildingIndex >= len(buildings_pre):
				buildingIndex = 0
		elif event.is_action_pressed("previous_building"):
			buildingIndex -= 1
			if buildingIndex < 0:
				buildingIndex = len(buildings_pre) - 1
		building = buildings_pre[buildingIndex].instantiate()
		add_child(building)

func _ready() -> void:
	var orbitals = planets.get_children()
	var orbitables: Array[Orbitable] = []
	for i in range(len(orbitals)):
		if orbitals[i] is Orbitable:
			orbitables.append(orbitals[i] as Orbitable)
	
	PlanetManager.load_planets(orbitables)
	
	Game.set_oil(startingOil)
	Game.set_metal(startingMetal)
	Game.set_crystal(startingCrystal)
	Game.set_funds(startingFunds)
