class_name Asteroid
extends RigidBody2D

@export var earthmass := 96.3 # Unit: Mass of Earth
@onready var timer: Timer = $Timer

@export var health := 10

@onready var col = $CollisionShape2D
@onready var spr = $Asteroid
var dir
var global_pos
var leftspawner:bool
var noPull: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
  #col.shape.radius = (spr.texture.get_width() +spr.texture.get_height()) / 4
	dir  =  randi_range(1,10) # chosing a random direction
	#print(dir)
	timer.start()
	
	if (global_pos!=null): #stopping existing asteroids fromm resetting
		_set_position(global_pos.x, global_pos.y)

func get_radius() -> float:
	return (spr.texture.get_width() + spr.texture.get_height()) / 4

func take_damage(amount):
	health -= amount
	print("took " + str(amount) + " damage")
	if health <= 0:
		destroy()

func destroy():
	get_parent().call_deferred("remove_child", self)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(noPull):
		if(!leftspawner):
			match dir:
				1:
					linear_velocity.y = -30
					linear_velocity.x = -96.5
				2:
					linear_velocity.y = + 40.23
					linear_velocity.x = -80.7
				3:
					linear_velocity.y = -30.23
					linear_velocity.x = -80.26 
				4:
					linear_velocity.y = +20
					linear_velocity.x = -80.7
				5:
					linear_velocity.y = -40.25
					linear_velocity.x = -80.32
				6:
					linear_velocity.y = +60.24
					linear_velocity.x = -80.28
				7:
					linear_velocity.y = -36.3
					linear_velocity.x = -80.22
				8:
					linear_velocity.y = +20.23
					linear_velocity.x = -80.23
				9:
					linear_velocity.y = +60.07
					linear_velocity.x = -100 
				10:
					linear_velocity.y = -20
					linear_velocity.x = -80.23
		else:
			match dir:
				1:
					linear_velocity.y = - 70.2
					linear_velocity.x = +80.25
				2:
					linear_velocity.y = + 20.3
					linear_velocity.x = +80.26
				3:
					linear_velocity.y = -10.3
					linear_velocity.x = +80.26 
				4:
					linear_velocity.y = +50.232
					linear_velocity.x = +80.27
				5:
					linear_velocity.y = -36.43
					linear_velocity.x = +80.22
				6:
					linear_velocity.y = +80.24
					linear_velocity.x = +80.28
				7:
					linear_velocity.y = -56.3
					linear_velocity.x = +80.2
				8:
					linear_velocity.y = +30.23
					linear_velocity.x = +80.24
				9:
					linear_velocity.y = +40.21
					linear_velocity.x = +80.7 
				10:
					linear_velocity.y = -30.2
					linear_velocity.x = +80.24
	
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
	#print("entered")
	destroy()
	
