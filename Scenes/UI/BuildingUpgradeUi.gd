extends Control
class_name BuildingUpgradeUI

var data : BuildingUpgradeCostResource

var is_open := false

func _ready():
	# Game._MONEYCHEATHECKYEAH()
	showitem((get_parent() as Building).buildingLevel)
	visible = false

func _on_buy_pressed():
	if is_open:
		buyitem()
		close()

func open():
	if not is_open:
		showitem((get_parent() as Building).buildingLevel)
		visible = true
		Game.toggle_pause(true)
		is_open = true

func close():
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
	(get_parent() as Building).sell()
