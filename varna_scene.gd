extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var SOCKET_URL = "ws://194.15.112.30:6988"

var client = WebSocketClient.new()

onready var items = []
var tableitems = []
var tablecount = 0
onready var player = get_node("player")
var varnaID

onready var textbox = get_node("textbox")

var pod = load("res://assets/pod.png")
var weed_1 = load("res://assets/weed_1.png")
var weed_2 = load("res://assets/weed_2.png")
var weed_3 = load("res://assets/weed_3.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	client.connect("connection_closed", self, "_on_connection_closed")
	client.connect("connection_error", self, "_on_connection_closed")
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data")
	
	var err = client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	textbox.visible = false
	varnaID = player.scene
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
	textbox.visible = true
	textbox.text = "You just planted a seed"
	item.set_texture(weed_1)
	yield(get_tree().create_timer(3.0), "timeout")
	item.set_texture(weed_2)
	textbox.visible = false
	yield(get_tree().create_timer(3.0), "timeout")
	item.set_texture(weed_3)
	
func _get_tablenumber():
	var body = $player/body.get_overlapping_areas()
	tablenumber = null
	if (body.size()==0):
		print(body)
		pass
	else:
		var table = body[0]
		for i in tablecount+1:
			if(table.name == "table" + String(i)):
				print(i)
				tablenumber = i
				break

func _weedharvest(var i,var grams):
	if tablenumber == null:
		pass
	else:
		items[i].set_texture(pod)
		textbox.visible = true
		textbox.text = "You just harvested " + grams + " weed"
		yield(get_tree().create_timer(3.0), "timeout")
		textbox.visible = false

func _weedstart_weedharvest(var i, var text):
	if (items[i].texture == weed_3):
		i+=1
		_send("weedharvest"+text+"$"+ varnaID + "$"+String(i))
		firsttime = "n"
	else:
		i+=1
		_send("weedstart"+text+"$"+ varnaID + "$"+String(i) + "$0")
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
				items.append(get_node("table"+ String(i) +"/Sprite"))
				_set_item(x[m],x[n],items[i])
				tablecount = i
				tableitems.append(x[m])
				n+=2
				m+=2

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
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
		else:
			firsttime = "y"

func _on_leave_body_entered(body):
	get_tree().change_scene("res://Trebic.tscn")
