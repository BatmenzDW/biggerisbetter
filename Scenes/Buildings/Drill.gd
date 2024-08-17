class_name Drill

extends Building

@onready var target_area: Area2D = $Target

var target: Building

var itemA_pre = preload("res://Scenes/Item.tscn")

func _clock() -> void:
	var item = itemA_pre.instantiate()
	contents.append(item)
	add_child(item)
	
	#print(len(contents))
	#print(target)
	
	if target != null:
		if has_contents():
			var cont = contents.duplicate()
			for item_c in cont:
				if target.has_space(item_c):
					contents.erase(item_c)
					remove_child(item)
					target.add_child(item)
					target.recieve_item(item_c)
				else:
					#print("target has no space")
					pass

func update() -> void:
	#print("Drill updated")
	var overlaps = target_area.get_overlapping_areas()
	for overlap in overlaps:
		if overlap != self:
			target = (overlap as Building)
			#print(target.name + " is targeted")
			break

func has_contents() -> bool:
	return not contents.is_empty()
