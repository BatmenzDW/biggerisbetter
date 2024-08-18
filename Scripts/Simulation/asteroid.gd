class_name Asteroid
extends RigidBody2D

@export var earthmass := 0.1 # Unit: Mass of Earth
@onready var timer: Timer = $Timer

@onready var col = $CollisionShape2D
@onready var spr = $Asteroid
var dir
var global_pos
var leftspawner:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	col.shape.radius = (spr.texture.get_width() + spr.texture.get_height()) / 4
	dir  =  randi_range(1,10) # chosing a random direction
	#print(dir)
	timer.start()
	
	if (global_pos!=null): #stopping existing asteroids fromm resetting
		_set_position(global_pos.x, global_pos.y)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!leftspawner):
		match dir:
			1:
				position.y -= 1
				position.x -= 5
			2:
				position.y +=  3
				position.x -= 7
			3:
				position.y -= 3
				position.x -= 6 
			4:
				position.y += 2
				position.x -= 7
			5:
				position.y -= 3
				position.x -= 2
			6:
				position.y += 4
				position.x -= 8
			7:
				position.y -=  3
				position.x -= 2
			8:
				position.y += 3
				position.x -= 3
			9:
				position.y += 1
				position.x -= 1 
			10:
				position.y -= 2
				position.x -= 2
	else:
		match dir:
			1:
				position.y -= 2
				position.x += 5
			2:
				position.y +=  3
				position.x += 6
			3:
				position.y -= 3
				position.x += 6 
			4:
				position.y += 2
				position.x += 7
			5:
				position.y -= 3
				position.x += 2
			6:
				position.y += 4
				position.x += 8
			7:
				position.y -=  3
				position.x += 2
			8:
				position.y += 3
				position.x += 3
			9:
				position.y += 1
				position.x += 1 
			10:
				position.y -= 2
				position.x += 2
	
	global_pos = global_position
	


func _on_timer_timeout() -> void:
	queue_free()
	
func _set_position(x: float, y:float):
	self.position.x = x
	self.position.y = y
	
func _set_leftspawner(lspawner:bool):
	leftspawner = lspawner


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage()
	queue_free()
