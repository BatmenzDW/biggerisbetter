extends Building
class_name Rocket


var loaded_population := 0.0
@export var load_percent := 0.1
@export var load_speed := 0.1
@export var max_load := 100.0

var landing_pad : LandingPad

func _load_population() -> void:
	if orbiting:
		var perc_pop = orbiting.planetPopulation * load_percent * load_speed
		var to_load = min(perc_pop, max_load * load_speed)
		to_load = ceil(to_load)
		#print("loaded " + str(to_load) + " ppl")
		loaded_population += to_load
		orbiting.planetPopulation -= to_load

func remove(refund:bool=true) -> void:
	if refund:
		_refund()
		Game.recieve_funds(buildCost/2)
	get_parent().remove_child(self)
	queue_free()

func set_landing_pad(pad: LandingPad):
	landing_pad = pad
	pad.parent = self

func _clock() -> void:
	if not landing_pad:
		return
	if loaded_population < max_load and landing_pad.orbiting:
		#print("loading population")
		_load_population()
		_update_tooltip()
	if loaded_population >= max_load and landing_pad.orbiting:
		print("launching")
		_launch()

func _make_tooltip() -> String:
	return buildingName + str(buildingLevel) + "\n\n" + \
		"Loaded: \n" +\
		"	" + str(int(loaded_population)) + "/" + str(int(max_load))

func _launch() -> void:
	# TODO: add transition Animation
	if landing_pad.orbiting.planetPopulation == -1:
		landing_pad.orbiting.planetPopulation = loaded_population
	else:
		landing_pad.orbiting.planetPopulation += loaded_population
	
	landing_pad.remove(false)
	self.remove(false)

func upgrade(data:BuildingUpgradeCostResource) -> bool:
	if not Game.purchase_upgrade(data):
		return false
	if data.level == 4:
		SignalBus.max_rocket_built.emit()
	
	buildingLevel = data.level
	sprite.texture = data.new_texture
	#productionCost = data.prodCost
	
	load_percent = data.load_percent
	load_speed = data.load_speed
	max_load = data.max_load
	
	oilCost += data.oil
	metalCost += data.metal
	crystalCost += data.crystal
	fundsCost += data.funds
	
	return true
