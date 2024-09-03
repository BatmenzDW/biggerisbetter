extends Control
class_name BuildingUpgradeUI

var data : BuildingUpgradeCostResource

var is_open := false

var is_panel_clicked = false

func _ready():
	# Game._MONEYCHEATHECKYEAH()
	SignalBus.connect("building_upgrade_ui_close", close)
	showitem((get_parent() as Building).buildingLevel)
	visible = false

func _on_buy_pressed():
	if is_open:
		buyitem()
		close()
		_ready()
		open()

func open():
	if(self.get_parent().get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").buildindex != 0):
		self.get_parent().get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").previndex = self.get_parent().get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").buildindex
	self.get_parent().get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI")._on_item_list_item_selected(0)
	
	if(get_parent().get_parent().get_parent().get_parent().get_node("UI").get_node("Upgrade_UI").visible == true):
		SignalBus.emit_signal("planet_ui_close")
	
	self.global_position = get_parent().get_parent().get_parent().get_parent().get_node("Camera2D").position - Vector2 (148, 156)
	
	Game.overlap += 1
	if not is_open:
		showitem((get_parent() as Building).buildingLevel)
		visible = true
		
		#if(get_tree().paused == false):
			#Game.overlap += 1
			
		Game.toggle_pause(true)
		
		is_open = true

func close():
	if is_open:
		self.get_parent().get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI")._on_item_list_item_selected(self.get_parent().get_parent().get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").previndex)
		Game.overlap -= 1
		data = null
		visible = false
		is_open = false
		Game.toggle_pause(false)
	

func close_quiet():
	data = null
	visible = false
	is_open = false

func _on_close_pressed():
	if is_open:
		close()

func buyitem():
	if data != null:
		(get_parent() as Building).upgrade(data)

func format_number(n: int) -> String:
	if n >= 1_000_000:
		return str(float(n) / 1_000_000).replace(",", ".") + "m"
	elif n >= 1_000:
		return str(float(n) / 1_000).replace(",", ".") + "k"
	else:
		return str(n)

func showitem(current_lvl:int):
	var text = ""
	$Panel/MarginContainer4/Buy.disabled = true
	if not (get_parent() as Building):
		return
	for upgrade in (get_parent() as Building).upgrades:
		if upgrade.level == current_lvl + 1:
			data = upgrade
			break
	
	if data != null:
		if data.oil:
			text += "-" + format_number(data.oil) + " Oil\n" 
		if data.metal:
			text += "-" + format_number(data.metal) + " Metal\n" 
		if data.crystal:
			text += "-" + format_number(data.crystal) + " Crystal\n"
		if data.funds:
			text += "-" + format_number(data.funds) + " Funds\n" 
		
		$Panel/VBoxContainer/MarginContainer/UpgradeName.text = data.name + ":"
		if (
			Game.get_funds() >= data.funds and
			Game.get_metal() >= data.metal and
			Game.get_crystal() >= data.crystal and
			Game.get_oil() >= data.oil
		):
			$Panel/MarginContainer4/Buy.disabled = false
	else:
		$Panel/VBoxContainer/MarginContainer/UpgradeName.text = "Max Level"

	$Panel/VBoxContainer/MarginContainer3/Cost.text = text


func _on_sell_pressed() -> void:
	Game.toggle_pause()
	#Game.overlap -=1
	_on_close_pressed()
	(get_parent() as Building).sell()
	


#handle movement
func _on_panel_gui_input(event):
	if event is InputEventMouseButton:
		is_panel_clicked = event.pressed
		
	if event is InputEventMouseMotion && is_panel_clicked:
		global_position += event.relative
	pass # Replace with function body.
