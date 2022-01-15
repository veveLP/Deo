extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"

var client = WebSocketClient.new()

onready var items = []
var tableitems = []
var tablecount = 0
onready var player = get_node("varna/player")
var varnaID
var user = loadd()

onready var textbox = get_node("varna/textbox")

var pod = load("res://assets/pod.png")
var weed_1 = load("res://assets/weed_1.png")
var weed_2 = load("res://assets/weed_2.png")
var weed_3 = load("res://assets/weed_3.png")

func _ready():
	client.connect("connection_closed", self, "_on_connection_closed")
	client.connect("connection_error", self, "_on_connection_closed")
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data")
	
	var err = client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	$varna/textbox.visible = false
	varnaID = $varna/player.scene
	varnaID.erase(0,11)

func _set_item(var drug, var state, var item):
	match drug:
		"weed":
			if (state != "0"):
				item.set_texture(weed_3)
			else:
				item.set_texture(pod)
		"meth":
			pass
		"heroin":
			pass
 
func _get_table_count(var x):
	return (x.size()-2)/2

func _weedstart(var item):
	print(OS.get_system_time_secs())
	$varna/textbox.visible = true
	$varna/textbox.text = "You just planted a seed"
	item.set_texture(weed_1)
	yield(get_tree().create_timer(3.0), "timeout")
	item.set_texture(weed_2)
	$varna/textbox.visible = false
	yield(get_tree().create_timer(3.0), "timeout")
	item.set_texture(weed_3)
	
func _get_tablenumber():
	var body = $varna/player/body.get_overlapping_areas()
	tablenumber = null
	if (body.size()==0):
		pass
	else:
		var table = body[0]
		for i in tablecount+1:
			if(table.name == "table" + String(i)):
				tablenumber = i
				break

func _weedharvest(var i,var grams):
	if tablenumber == null:
		pass
	else:
		items[i].set_texture(pod)
		$varna/textbox.visible = true
		$varna/textbox.text = "You just harvested " + grams + " weed"
		yield(get_tree().create_timer(3.0), "timeout")
		$varna/textbox.visible = false

func _weedstart_weedharvest(var i, var text):
	if (items[i].texture == weed_3):
		i+=1
		_send("weedharvest" + text + "$" + varnaID + "$" + String(i))
		firsttime = "n"
	elif (items[i].texture == pod):
		i+=1
		$varna.visible = false
		$WeedMinigame.visible = true
		$WeedMinigame/Timer.start()
		firsttime = "n"

func _process(delta):
	client.poll()
	
func loadd():
	var file = File.new()
	file.open("res://save_game.dat", File.READ)
	var content = file.get_line()
	file.close()
	return content

func _on_connection_closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)
	
func _on_connected(proto = ""):
	var text = loadd()
	print("Connected with protocol: ", proto)
	_send("loadinterior"+ text +"$" + varnaID)
	
func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	var x = payload.split("$")
	match x[0]:
		"weedstart":
			_weedstart(items[tablenumber])
		"weedharvest":
			_weedharvest(tablenumber,x[1])
		"loadinterior":
			var m = 1
			var n = 2
			for i in _get_table_count(x):
				items.append(get_node("varna/table"+ String(i) +"/Sprite"))
				_set_item(x[m],x[n],items[i])
				tablecount = i
				tableitems.append(x[m])
				n+=2
				m+=2

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)

var firsttime = "y"
var tablenumber = null

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			_get_tablenumber()
			if tablenumber == null:
				pass
			else:
				match tableitems[tablenumber]:
					"weed":
						_weedstart_weedharvest(tablenumber,loadd())
					"meth":
						pass
					"heroin":
						pass
		elif event.scancode == KEY_Q and firsttime == "y":
			user = loadd()
			_get_tablenumber()
			if tablenumber == null:
				pass
			else:
				$varna.visible = false
				$vyber.visible = true
				firsttime = "n"
		else:
			firsttime = "y"

func _on_leave_body_entered(body):
	get_tree().change_scene("res://Trebic.tscn")

func _on_ButtonSelect_pressed():
	$WeedMinigame/Timer.stop()
	var Quantity 
	var PBvalue = $WeedMinigame/ProgressBar.value
	var i = tablenumber + 1
	if PBvalue >= 0 && PBvalue < 12 || PBvalue > 88:
		Quantity = 4
	elif PBvalue >= 12 && PBvalue < 23 || PBvalue > 77 && PBvalue <= 88:
		Quantity = 3
	elif PBvalue >= 23 && PBvalue < 34 || PBvalue > 66 && PBvalue <= 77:
		Quantity = 2
	elif PBvalue >= 34 && PBvalue < 45 || PBvalue > 55 && PBvalue <= 66:
		Quantity = 1
	else:
		Quantity = 0
	_send("weedstart" + loadd() + "$" + varnaID + "$" + str(i) + "$" + str(Quantity))
	$WeedMinigame.visible = false
	$varna.visible = true

func _on_Timer_timeout():
	if $WeedMinigame/ProgressBar.value == 100:	
		$WeedMinigame/ProgressBar.value = 0;
	else:
		$WeedMinigame/ProgressBar.value += 5
	


func _on_weed_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$weed")
	items[tablenumber].set_texture(pod)
	tableitems[tablenumber] = "weed"
	$vyber.visible = false
	$varna.visible = true


func _on_heroin_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$heroin")
	items[tablenumber].set_texture(null)
	tableitems[tablenumber] = "heroin"
	$vyber.visible = false
	$varna.visible = true # Replace with function body.


func _on_meth_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$meth")
	items[tablenumber].set_texture(null)
	tableitems[tablenumber] = "meth"
	$vyber.visible = false
	$varna.visible = true # Replace with function body.
