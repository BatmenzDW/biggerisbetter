extends Node2D

@onready var planets: Node = $Planets

@export var startingOil : int
@export var startingMetal : int
@export var startingCrystal : int
@export var startingFunds : int = 5000

var drill_pre = preload("res://Scenes/Buildings/drill.tscn")

var building: Building

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_building"):
		if building == null:
			building = drill_pre.instantiate()
			add_child(building)
	elif event.is_action_pressed("place_building"):
		if building != null:
			if building.place():
				building = building.self_preload.instantiate()
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
