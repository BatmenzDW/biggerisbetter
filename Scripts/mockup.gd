extends Node2D

var building: Building

var drill_pre = preload("res://Scenes/Buildings/drill.tscn")
var conveyer_pre = preload("res://Scenes/Buildings/conveyer.tscn")

var built: Array[Building] = []

@onready var score_txt: RichTextLabel = $CanvasLayer/Score
var score = 0

#func _ready() -> void:
	#get_tree().paused = true
#
#func _input(event: InputEvent) -> void:
	##if event.is_action_pressed("ui_accept"):
		##get_tree().paused = false
	#if event is InputEventMouseButton:
		#is_placeable = false
	#elif event is InputEventMouseMotion:
		#if is_placeable:
			#var new_postion = get_viewport().get_mouse_position()
			#placeable.global_position = snapped(new_postion, SNAP)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#drill.show()
		#drill.is_active = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_building"):
		if building == null:
			building = drill_pre.instantiate()
			add_child(building)
	else:
		_place_building(event)

func _place_building(event: InputEvent) -> void:
	if event.is_action_pressed("place_drill"):
		if building is Drill:
			building.place()
			built.append(building)
			building = null
		else:
			if building != null:
				remove_child(building)
				building.queue_free()
			building = drill_pre.instantiate()
			add_child(building)
	elif event.is_action_pressed("place_conveyer"):
		if building is Conveyer:
			building.place()
			built.append(building)
			building = null
		else:
			if building != null:
				remove_child(building)
				building.queue_free()
			building = conveyer_pre.instantiate()
			add_child(building)

func _increase_score(amount: int):
	score += amount
	score_txt.text = "Score: " + str(score)

func _ready() -> void:
	Game.score.connect(_increase_score)
