extends Node

signal clock
signal update_score

const start_menu = preload("res://Scenes/UI/start_menu.tscn")
const game_over_screen = preload("res://Scenes/UI/game_over.tscn")
const WIN_SCREEN = preload("res://Scenes/UI/win_screen.tscn")

var levels = [
	preload("res://Scenes/Levels/randomsystem.tscn"),
]
var level_index = 0

var _time_passed = 0.0
var in_game := false

#const MASS_SCALE = 5.972e+24
const MASS_SCALE = 5.972e+3

func _update_score():
	update_score.emit()

func _process(delta: float) -> void:
	if not in_game:
		return
	
	_time_passed += delta
	if _time_passed >= 1:
		var t: int = floori(_time_passed)
		_time_passed -= t
		for i in range(t):
			clock.emit()

var _oil := 0

func get_oil() -> int:
	return _oil
func set_oil(amount:int):
	_oil = amount
	_update_score()
func recieve_oil(amount:int):
	_oil += amount
	_update_score()
func spend_oil(amount:int) -> bool:
	if _oil >= amount:
		_oil -= amount
		_update_score()
		return true
	return false

var _metal := 0

func get_metal() -> int:
	return _metal
func set_metal(amount:int):
	_metal = amount
	_update_score()
func recieve_metal(amount:int):
	_oil += amount
	_update_score()
func spend_metal(amount:int) -> bool:
	if _metal >= amount:
		_metal -= amount
		_update_score()
		return true
	return false

var _crystal := 0

func get_crystal() -> int:
	return _crystal
func set_crystal(amount:int):
	_crystal = amount
	_update_score()
func recieve_crystal(amount:int):
	_crystal += amount
	_update_score()
func spend_crystal(amount:int) -> bool:
	if _crystal >= amount:
		_crystal -= amount
		_update_score()
		return true
	return false

var _funds := 0

func get_funds() -> int:
	return _funds
func set_funds(amount:int):
	_funds = amount
	_update_score()
func recieve_funds(amount:int):
	_funds += amount
	_update_score()
func spend_funds(amount:int) -> bool:
	if _funds >= amount:
		_funds -= amount
		_update_score()
		return true
	return false

func produce_resources(costs:ProdCostResource, population:int) -> bool:
	if not _has_resources(costs, population):
		return false
	
	_oil += costs.oil_output - costs.oil
	_metal += costs.metal_output - costs.metal
	_crystal += costs.crystal_output - costs.crystal
	_funds += costs.funds_output - costs.funds
	
	_update_score()
	
	return true

func _has_resources(costs:ProdCostResource, population:int) -> bool:
	return _oil >= costs.oil and _metal >= costs.metal and _crystal >= costs.crystal \
		and _funds >= costs.funds and (population > costs.minPopulation or costs.minPopulation == -1)

func purchase_upgrade(data:BuildingUpgradeCostResource) -> bool:
	if _oil >= data.oil and _metal >= data.metal and _crystal >= data.crystal \
		and _funds >= data.funds:
		_oil -= data.oil
		_metal -= data.metal
		_crystal -= data.crystal
		_funds -= data.funds
		return true
	return false

func win(level: Level) -> void:
	in_game = false
	var win_screen_ = WIN_SCREEN.instantiate()
	get_tree().root.remove_child(level)
	level.queue_free()
	PlanetManager.unload_all()
	get_tree().root.add_child(win_screen_)

func game_over(level: Level)->void:
	in_game = false
	var game_over_ = game_over_screen.instantiate()
	get_tree().root.remove_child(level)
	level.queue_free()
	PlanetManager.unload_all()
	get_tree().root.add_child(game_over_)

func start_game(caller:Node)->void:
	in_game = true
	var level = levels[level_index].instantiate()
	get_tree().root.remove_child(caller)
	caller.queue_free()
	get_tree().root.add_child(level)

func next_level(prev_level: Level)->void:
	level_index += 1
	var level = levels[level_index].instantiate()
	get_tree().root.remove_child(prev_level)
	prev_level.queue_free()
	get_tree().root.add_child(level)
	(level as Level).start_level()


func _MONEYCHEATHECKYEAH():
	set_funds(999999)
	set_metal(999999)
	set_oil(999999)
	set_crystal(999999)


func toggle_pause():
	get_tree().paused = not get_tree().paused
