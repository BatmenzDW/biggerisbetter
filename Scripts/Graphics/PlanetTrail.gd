class_name Trail
extends Line2D

#const MAX_POINTS: int = 2000
@onready var curve := Curve2D.new()

const MIN_DELTA : float = 0.015

var total_delta := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	total_delta += delta
	if total_delta < MIN_DELTA:
		return
	
	var scalemod = Vector2(1 / get_parent().scale.x, 1 / get_parent().scale.y)
	var radius = get_parent().orbitalRadius
	
	if (get_parent() as Orbitable).orbiting == null:
		return
	var offset = get_parent().position.direction_to(get_parent().orbiting.position) * radius
	
	position = offset * scalemod
	
	var maxpoints = 2*radius
	
	for i in range(total_delta/MIN_DELTA):
		curve.add_point((get_parent().position * scalemod))
		if curve.get_baked_points().size() > maxpoints:
			curve.remove_point(0)
	
	total_delta -= int(total_delta/MIN_DELTA) * MIN_DELTA
	points = curve.get_baked_points()
