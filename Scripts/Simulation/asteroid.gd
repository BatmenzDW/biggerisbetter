class_name Asteroid
extends RigidBody2D

@export var earthmass := 0.1 # Unit: Mass of Earth

@onready var col = $CollisionShape2D
@onready var spr = $Asteroid

# Called when the node enters the scene tree for the first time.
func _ready():
	col.shape.radius = (spr.texture.get_width() + spr.texture.get_height()) / 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
