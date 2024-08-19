extends Building

class_name LandingPad

var parent: Rocket

func _make_tooltip() -> String:
	return buildingName + str(buildingLevel)

func _clock() -> void:
	pass

func _check_placement() -> bool:
	if parent.orbiting == nearestOrbit:
		sprite.modulate = Color.RED
		return false
	if len(get_overlapping_areas()) == 0 and nearestOrbit != null:
		sprite.modulate = Color.WHITE
		return true
	sprite.modulate = Color.RED
	return false
