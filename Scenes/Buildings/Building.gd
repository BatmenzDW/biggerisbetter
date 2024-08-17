extends Area2D

class_name Building

@onready var sprite: Sprite2D = $Sprite
@onready var updater: Area2D = $BuildingUpdater

var is_placing: bool = true

var contents: Array[Item] = []

var clock_cycles = 0
var max_cycles = 1

const SNAP: Vector2 = Vector2(32, 32)
const EPSILON = 0.5

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if is_placing:
			var new_postion = get_viewport().get_mouse_position()
			global_position = snapped(new_postion, SNAP)
			_check_placement()


func place() -> void:
	print("Placing " + name)
	if _check_placement():
		is_placing = false
		Game.clock.connect(_clock)
		_send_updates()
	else:
		print("Can't build due to overlap.")

func _ready() -> void:
	pass

func _clock() -> void:
	pass

func _check_placement() -> bool:
	if len(get_overlapping_areas()) == 0:
		sprite.modulate = Color.WHITE
		return true
	sprite.modulate = Color.RED
	return false

func _send_updates() -> void:
	var targets = updater.get_overlapping_areas()
	for target in targets:
		print(target.name)
		if target.has_method("update"):
			target.update()

func update() -> void:
	pass

func has_space(item: Item) -> bool:
	return false

func recieve_item(item: Item) -> void:
	pass

func has_contents() -> bool:
	return false
