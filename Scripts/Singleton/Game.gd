extends Node

signal clock
signal update_score

var _time_passed = 0.0

func _update_score():
	update_score.emit()

func _process(delta: float) -> void:
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
		and _funds >= costs.funds and (population <= costs.maxPopulation or costs.maxPopulation == -1)
