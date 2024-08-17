class_name Conveyer

extends Building

@onready var target_area: Area2D = $Target

var target: Building

func _clock() -> void:
	pass

func update() -> void:
	var overlaps = target_area.get_overlapping_areas()
	for overlap in overlaps:
		if overlap != self:
			target = overlap as Building
			break
