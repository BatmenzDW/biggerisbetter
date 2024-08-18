extends Control

@onready var list: ItemList = $MarginContainer/HBoxContainer/ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.building_selected_input.connect(_select)
	SignalBus.building_deselected_input.connect(_deselect)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_item_list_item_selected(index: int) -> void:
	SignalBus.building_selected_gui.emit(index)


func _deselect():
	list.deselect_all()

func _select(index:int):
	list.select(index)
