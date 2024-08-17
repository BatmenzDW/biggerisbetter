class_name Drill

extends Building

func update() -> void:
	pass
	#print("Drill updated")
	#var overlaps = target_area.get_overlapping_areas()
	#for overlap in overlaps:
		#if overlap != self:
			#target = (overlap as Building)
			##print(target.name + " is targeted")
			#break

func has_contents() -> bool:
	return not contents.is_empty()
