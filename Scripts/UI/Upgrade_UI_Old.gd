extends Control

var planet
# Called when the node enters the scene tree for the first time.
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var upgrades = []
var currentitem = -1

var is_panel_clicked = false

# Use the "Upgrade ID' field in an Upgrade Struct
func handleupgrade(id):
	match id:
		"20health":
			planet.gain_health(20)
		
			
		"20resist":
			planet.damage -= (.2 * planet.damage)

func format_number(n: int) -> String:
	if n >= 1_000_000:
		return str(float(n) / 1_000_000).replace(",", ".") + "m"
	elif n >= 1_000:
		return str(float(n) / 1_000).replace(",", ".") + "k"
	else:
		return str(n)

func updatelist():
	upgrades = []
	
	$Panel/ItemList.clear()
	
	for x in $Upgrades.get_children():
		upgrades.push_back(x)
		$Panel/ItemList.add_item(x.upgrade)
		showitem(-1)

func showitem(i):
	var text = ""
	$Panel/Buy.disabled = true
	
	#print(upgrades[i].funds)
	
	if len(upgrades) > i:
		if upgrades[i].oil:
			text += "-" + format_number(upgrades[i].oil) + " Oil\n"
		if upgrades[i].metal:
			text += "-" + format_number(upgrades[i].metal) + " Metal\n" 
		if upgrades[i].crystal:
			text += "-" + format_number(upgrades[i].crystal) + " Crystal\n" 
		if upgrades[i].funds:
			text += "-" + format_number(upgrades[i].funds) + " Funds\n"  
		
		var item = upgrades[i]
		if (
			Game.get_funds() >= item.funds and
			Game.get_metal() >= item.metal and
			Game.get_crystal() >= item.crystal and
			Game.get_oil() >= item.oil
		):
			$Panel/Buy.disabled = false
		
	$Panel/Cost.text = text
	

func buyitem(i):
	if len(upgrades) >= i:
		var item = upgrades[i]
		if (
			Game._funds >= item.funds and
			Game._metal >= item.metal and
			Game._crystal >= item.crystal and
			Game._oil >= item.oil
		):	
			Game.spend_funds(item.funds)
			Game.spend_metal(item.metal)
			Game.spend_crystal(item.crystal)
			Game.spend_oil(item.oil)
			audio_stream_player.play()
			handleupgrade(item.upgrade_id)
	

func _ready():
	# Game._MONEYCHEATHECKYEAH()
	SignalBus.connect("planet_ui_close",_on_close_pressed)
	updatelist()
	visible = false;
func _process(delta: float) -> void:
	
	if(planet !=null):
		$Panel/PlanetInfo.text = "Health :\n\n" 
		if planet.planetPopulation < 0:
			$Panel/PlanetInfo.text += "Inhabitable"
		else:
			$Panel/PlanetInfo.text += "Polulation: " + str(planet.planetPopulation)
		$Panel/Healthbar.value = planet.planetHealth
		$Panel/Healthbar.max_value = planet.maxHealth
		
func open():
	
	updatelist()
	Game.overlap +=1
	if(get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").buildindex != 0):
		get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").previndex = get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").buildindex
	get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI")._on_item_list_item_selected(0)
	
	SignalBus.emit_signal("building_upgrade_ui_close")
	visible = true;
	if(get_tree().paused == false):
		Game.toggle_pause()

func close():
	visible = false
	Game.toggle_pause()
	

	
func _on_close_pressed():
	#if(visible == true):
		#Game.overlap -= 1
	Game.overlap -=1
	visible = false;
	get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI")._on_item_list_item_selected(get_parent().get_parent().get_node("CanvasLayer").get_node("BuildingUI").previndex)
	Game.toggle_pause()
	
	
func nplanet(body):
	planet = body


func _on_item_list_item_selected(index):
	showitem(index)
	if len(upgrades) >= index:
		currentitem = index
	else:
		currentitem = -1
	pass # Replace with function body.


func _on_buy_pressed():
	buyitem(currentitem)
	

#handle movement
func _on_panel_gui_input(event):
	if event is InputEventMouseButton:
		is_panel_clicked = event.pressed
		
	if event is InputEventMouseMotion && is_panel_clicked:
		global_position += event.relative
	pass # Replace with function body.
