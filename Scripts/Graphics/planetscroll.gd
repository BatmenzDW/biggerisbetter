extends Node2D

class_name PlanetScroll

@export var ptext : Texture2D = preload("res://Assets/Art/Planets/earth-programmer-art.png")
@export var ptext1 : Texture2D = preload("res://Assets/Art/Planets/terra2.png")
@export var ptext2 : Texture2D = preload("res://Assets/Art/Planets/terra3.png")
@export var ptext3 : Texture2D = preload("res://Assets/Art/Planets/terra4.png")
@export var ptext4 : Texture2D = preload("res://Assets/Art/Planets/terra5.png")
@export var ptext5 : Texture2D = preload("res://Assets/Art/Planets/terra6.png")
@export var ptext6 : Texture2D = preload("res://Assets/Art/Planets/terra7.png")
@export var ptext7 : Texture2D = preload("res://Assets/Art/Planets/terra8.png")
@export var ptext8 : Texture2D = preload("res://Assets/Art/Planets/terra9.png")
@export var ptext9 : Texture2D = preload("res://Assets/Art/Planets/terra10.png")


@export var rotatespeed = 0.2 # How fast to rotate the planet?
							  # No real unit, relative to how big the planet sprite is

@onready var spr1 = $Sprite # Reference to the planet sprite.
var spr2 : Sprite2D 			 # This gets created later

var sprwidth = 0				 # Reference to how wide the planet sprite is

var scroll := 0.0				 # Scroll offset (From 0-1)
var skins = [ptext,ptext1, ptext2,ptext3,ptext4,ptext5,ptext6,ptext7,ptext8,ptext9]
var skinpick
# Called when the node enters the scene tree for the first time.
func _ready():
	
	skinpick = randi()% skins.size()

	spr1.texture = skins[skinpick]
	
	# Duplicate the planet sprite
	spr2 = spr1.duplicate()
	add_child(spr2)
	
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
