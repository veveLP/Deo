extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var SOCKET_URL = "ws://194.15.112.30:6988"

var client = WebSocketClient.new()

onready var items = [get_node("table0/Sprite"), get_node("table1/Sprite"),get_node("table2/Sprite"),get_node("table3/Sprite"),get_node("table4/Sprite")]

onready var planted = get_node("planted")
onready var harvested = get_node("harvested")

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
	planted.visible = false
	harvested.visible = false

func _set_item(var drug, var state, var item):
	if (drug == "weed"):
		if (state != "0"):
			item.set_texture(weed_3)
		else:
			item.set_texture(pod)
	elif (drug == "meth"):
		print("meth")
		pass
	elif (drug == "heroin"):
		print("heroin")
		pass

func _weedstart(var item):
	print(OS.get_system_time_secs())
	planted.visible = true
	item.set_texture(weed_1)
	yield(get_tree().create_timer(3.0), "timeout")
	item.set_texture(weed_2)
	planted.visible = false
	yield(get_tree().create_timer(3.0), "timeout")
	item.set_texture(weed_3)
	
func _get_tablenumber():
	if($table0.overlaps_body($player)):
		tablenumber = 0
	elif($table1.overlaps_body($player)):
		tablenumber = 1
	elif($table2.overlaps_body($player)):
		tablenumber = 2
	elif($table3.overlaps_body($player)):
		tablenumber = 3
	elif($table4.overlaps_body($player)):
		tablenumber = 4
	else:
		tablenumber = null
	
func _weedharvest(var i,var grams):
		items[i].set_texture(pod)
		harvested.visible = true
		harvested.text = "You just harvested " + grams + " weed"
		yield(get_tree().create_timer(3.0), "timeout")
		harvested.visible = false
	
func _weedstart_weedharvest(var i, var text):
	if i == null:
		pass
	elif (items[i].texture == weed_3):
		i+=1
		_send("weedharvest"+text+"$1$"+String(i))
		firsttime = "n"
	else:
		i+=1
		_send("weedstart"+text+"$1$"+String(i))
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
	_send("loadinterior"+ text +"$1")
	
func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	var x = payload.split("$")
	if (x[0] == "weedstart"):
		_weedstart(items[tablenumber])
	elif (x[0] == "weedharvest"):
		_get_tablenumber()
		_weedharvest(tablenumber,x[1])
	elif (x[0] == "loadinterior"):
		var m = 1
		var n = 2
		for i in 5:
			_set_item(x[m],x[n],items[i])
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
var tablenumber = 0

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			_get_tablenumber()
			_weedstart_weedharvest(tablenumber,loadd())
		else:
			firsttime = "y"

func _on_leave_body_entered(body):
	_send("Prcám na to leavuju")
	get_tree().change_scene("res://Trebic.tscn") # Replace with function body.
