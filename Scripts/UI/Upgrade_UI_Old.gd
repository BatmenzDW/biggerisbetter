extends Control

var planet
# Called when the node enters the scene tree for the first time.
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var upgrades = []
var currentitem = -1

# Use the "Upgrade ID' field in an Upgrade Struct
func handleupgrade(id):
	match id:
		"20health":
			planet.gain_health(20)
		
		"1population":
			planet.growth += 1
			
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
			Game.get_funds() >= item.funds &&
			Game.get_metal() >= item.metal &&
			Game.get_crystal() >= item.crystal &&
			Game.get_oil() >= item.oil
		):
			$Panel/Buy.disabled = false
		
	$Panel/Cost.text = text

func buyitem(i):
	if len(upgrades) >= i:
		var item = upgrades[i]
		if (
			Game._funds >= item.funds &&
			Game._metal >= item.metal &&
			Game._crystal >= item.crystal &&
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
	updatelist()
	visible = false;

func open():
	updatelist()
	visible = true;
	Game.toggle_pause()

func close():
	visible = false
	
	
func _on_close_pressed():
	visible = false;
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
	
