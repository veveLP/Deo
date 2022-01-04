extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var SOCKET_URL = "ws://194.15.112.30:6988"

var client = WebSocketClient.new()

onready var weed = get_node("table1/Sprite")

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
		print(OS.get_system_time_secs())
		planted.visible = true
		weed.set_texture(weed_1)
		yield(get_tree().create_timer(3.0), "timeout")
		weed.set_texture(weed_2)
		planted.visible = false
		yield(get_tree().create_timer(3.0), "timeout")
		weed.set_texture(weed_3)
	elif (x[0] == "weedharvest"):
		weed.set_texture(pod)
		harvested.visible = true
		harvested.text = "You just harvested " + x[1] + " weed"
		yield(get_tree().create_timer(3.0), "timeout")
		harvested.visible = false
	elif (x[0] == "loadinterior"):
		if(x[2] != "0"):
			weed.set_texture(weed_3)

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var firsttime = "y"

func _input(event):
	var text = loadd()
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y" and $table1.overlaps_body($player):
			if (weed.texture == weed_3):
				_send("weedharvest"+text+"$1$1")
				firsttime = "n"
			else:
				_send("weedstart"+text+"$1$1")
				firsttime = "n"
		else:
			firsttime = "y"

func _on_leave_body_entered(body):
	_send("Prcám na to leavuju")
	get_tree().change_scene("res://Trebic.tscn") # Replace with function body.
