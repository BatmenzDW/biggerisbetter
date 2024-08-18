class_name Conveyer

extends Building

@onready var target_area: Area2D = $Target

var target: Building

var speed: float = 25.0

func _ready() -> void:
	super._ready()
	contents = []


func _clock() -> void:
	if target != null:
		if has_contents():
			var cont = contents.duplicate()
			for item in cont:
				if target.has_space(item):
					if (item as Item).global_position.distance_to(global_position) <= EPSILON:
						contents.erase(item)
						target.recieve_item(item)
					else:
						print("Not same spot: " + str((item as Item).global_position.distance_to(global_position)))

func update() -> void:
	var overlaps = target_area.get_overlapping_areas()
	for overlap in overlaps:
		if overlap != self:
			target = overlap as Building
			break

func has_contents() -> bool:
	for c in contents:
		if c != null:
			return true
	return false

func has_space(item: Item) -> bool:
	if contents.is_empty():
		return true
	#print(contents)
	return false

func recieve_item(item: Item) -> void:
	#print(item.name + " recieved")
	item.speed = speed
	item.show()
	contents.append(item)
	item.move_to(global_position)
