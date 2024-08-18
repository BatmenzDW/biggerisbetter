class_name Asteroid
extends RigidBody2D

@export var earthmass := 0.1 # Unit: Mass of Earth

@export var health := 10

@onready var col = $CollisionShape2D
@onready var spr = $Asteroid

# Called when the node enters the scene tree for the first time.
func _ready():
	col.shape.radius = (spr.texture.get_width() + spr.texture.get_height()) / 4

func get_radius() -> float:
	return (spr.texture.get_width() + spr.texture.get_height()) / 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(amount):
	health -= amount
	print("took " + str(amount) + " damage")
	if health <= 0:
		destroy()

func destroy():
	get_parent().remove_child(self)
	queue_free()
