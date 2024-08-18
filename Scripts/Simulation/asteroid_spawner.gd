extends Node2D

var asteroid = preload("res://Scenes/Prefabs/asteroid.tscn")
@onready var timer: Timer = $Timer
@export var leftsidespawner:bool
func _ready():
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_timer_timeout() -> void:
	var item = asteroid.instantiate()
	#item.global_position = Vector2(randi_range(10,500),randi_range(10,200))
	item.global_position = global_position
	item._set_leftspawner(leftsidespawner)
	
	if get_parent().has_node("Asteroid Field"):
		get_parent().get_node("Asteroid Field").add_child(item)
	
	#print("asteroid spawned")
