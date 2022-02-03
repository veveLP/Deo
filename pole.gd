extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"
var client = WebSocketClient.new()
func _ready():
	var loaded = loadd()
	#print (loaded)
	var x = loaded.split("$")
	#print (x[1])
	
	client.connect("connection_closed", self, "_on_connection_closed")
	client.connect("connection_error", self, "_on_connection_closed")
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data")

	var err = client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	_send("loadpole" +text)

func _process(delta):
	client.poll()
func _on_connection_closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

var text = loadd()

func _on_connected(proto = ""):
	pass

func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	print(payload)
	


func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)
func loadd():
	var file = File.new()
	file.open("res://save_game.dat", File.READ)
	var content = file.get_line()
	file.close()
	return content
func save(content):
	var file = File.new()
	file.open("res://save_game.dat", File.WRITE)
	file.store_string(content)
	file.close()
var check = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = 0
var count = 0
var pole = [0,0,0,0]
var error = 0

# Called when the node enters the scene tree for the first time.


func _on_leave_body_exited(body):
	get_tree().change_scene("res://Trebic.tscn")
	

var tablenumber = null
var tablecount = 32
var tableitems = []
var firsttime = "y"

func _get_tablenumber():
	var body = $player/body.get_overlapping_areas()
	tablenumber = null
	if (body.size()==0):
		pass
	else:
		var table = body[0]
		for i in tablecount+1:
			if(table.name == "slot" + String(i)):
				tablenumber = i
				OS.alert(str(tablenumber))
				print(str(tablenumber))
				#_send(makoviceharvest$nickname$<pass>$cislomakovice)
				_send("makoviceharvest" +text+ "$"+str(tablenumber))
				
				
				break


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			firsttime = "n"
			_get_tablenumber()
			if tablenumber == null:
				pass
		else:
			firsttime = "y"



