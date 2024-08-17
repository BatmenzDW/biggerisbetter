extends Area2D

class_name Item

var count: int

var pos: Vector2

var speed: float = 3.0

const EPSILON = 0.5

func move_to(posi: Vector2):
	#print("Moving to new point")
	self.pos = posi

func _ready() -> void:
	hide()
	pos = global_position

func _physics_process(delta: float) -> void:
	#print("right process")
	if global_position == pos:
		return
	var distance = global_position.distance_to(pos)
	#print("Distance to point: " + str(distance))
	if distance > 0:
		if distance <= EPSILON:
			global_position = pos
			return
		var direction = global_position.direction_to(pos)
		var move_vector = direction * speed * delta
		global_position += move_vector
