extends Node2D

@export var rotatespeed = 0.2 # How fast to rotate the planet?
							  # No real unit, relative to how big the planet sprite is

@onready var spr1 = $Mask/Sprite # Reference to the planet sprite.
var spr2 : Sprite2D 			 # This gets created later

var sprwidth = 0				 # Reference to how wide the planet sprite is

var scroll := 0.0				 # Scroll offset (From 0-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Duplicate the planet sprite
	spr2 = spr1.duplicate()
	$Mask.add_child(spr2)
	
	# Get sprite width
	sprwidth = spr1.texture.get_width()
		
	# Set initial positions (Probably redundant)	
	spr1.position.x = sprwidth
	spr2.position.x = -sprwidth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Update scroll delta by delta frame
	# Multiply by rotatespeed and wrap it from 0 - 1
	scroll += delta * rotatespeed
	scroll = wrapf(scroll, 0, 1)
	
	# Set sprite positions based off of scroll delta and sprite width
	# This makes it so both sprites are scrolled through completely, and
	# the transition from 1 - 0 is seamless
	spr1.position.x = 2 * sprwidth * scroll
	spr2.position.x = spr1.position.x - 2 * sprwidth
