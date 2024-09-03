extends Control

var buildindex = 0
var previndex = 0

@onready var list: ItemList = $MarginContainer/HBoxContainer/ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.building_selected_input.connect(_select)
	SignalBus.building_deselected_input.connect(_deselect)
	$MarginContainer/HBoxContainer/ItemList.set_item_tooltip(1,"Drill ($250): \n(-1) crystal/s\n(+10) oil/s")
	$MarginContainer/HBoxContainer/ItemList.set_item_tooltip(2,"Metal Mine ($300): \n(-1) crystal/s\n(+10) metal/s")
	$MarginContainer/HBoxContainer/ItemList.set_item_tooltip(3,"Crystal Mine ($500): \n(-1) oil/s\n(-1) metal/s\n(+5) crystal/s")
	$MarginContainer/HBoxContainer/ItemList.set_item_tooltip(4,"Factory ($750): \n(-1) crystal/s\n(-10) oil/s\n(+1000) fund/s")
	$MarginContainer/HBoxContainer/ItemList.set_item_tooltip(5,"Turret ($500): \n(-1) crystal per shot\n(+5) damage per shot")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_item_list_item_selected(index: int) -> void:
	SignalBus.building_selected_gui.emit(index)
	_select(index)
	buildindex = index


func _deselect():
	list.deselect_all()

func _select(index:int):
	list.select(index)


func _on_item_list_mouse_entered() -> void:
	Game.overlap += 1


func _on_item_list_mouse_exited() -> void:
	Game.overlap -= 1
