extends Node2D

var asteroid = preload("res://Scenes/Prefabs/asteroid.tscn")
@onready var timer: Timer = $Timer
@export var leftsidespawner:bool

@export var spawnradius := 1000

func _ready():
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_timer_timeout() -> void:
	var item = asteroid.instantiate()
	#item.global_position = Vector2(randi_range(10,500),randi_range(10,200))
	
	var circlepos = randf_range(-PI, PI)
	var spawnpos = Vector2(cos(circlepos), sin(circlepos)) * spawnradius
	
	#item.global_position = global_position
	item.global_position = global_position + spawnpos
	item._set_leftspawner(leftsidespawner)
	
	if get_parent().has_node("Asteroid Field"):
		get_parent().get_node("Asteroid Field").add_child(item)
	
	#print("asteroid spawned")
