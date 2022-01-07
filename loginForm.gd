extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"
var client = WebSocketClient.new()

func _ready():
	var loaded = loadd()
	#print (loaded)
	var x = loaded.split("$")
	#print (x[1])
	$Panel/LineEdit.text = x[1]
	client.connect("connection_closed", self, "_on_connection_closed")
	client.connect("connection_error", self, "_on_connection_closed")
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data")
	
	var err = client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _process(delta):
	client.poll()

func _on_connection_closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)
	
	
func _on_connected(proto = ""):
	pass
	#var text = loadd()
	#print("Connected with protocol: ", proto)
	#_send("loadmap" + text)
	
func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	if payload == "error 0x01":
		print ("cancel login")
		OS.alert("Zadal jsi špatné údaje")
	else:
		print("login succesfull")
		var password = $Panel/LineEdit2.text
		print(password.sha256_text())
		password = password.sha256_text()
		password = password.left(10)
		save("$"+$Panel/LineEdit.text+"$"+password)
		get_tree().change_scene("res://Trebic.tscn")
		if (check):
			OS.window_fullscreen = true
		else:
			OS.window_size = Vector2(1920,1080)
	
		

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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

func _on_Button_pressed():
	login()


func _on_CheckBox_toggled(button_pressed):
	if (check):
		check = false
	else:
		check = true


func _on_LineEdit2_text_entered(new_text):
	login()

func login():
	print($Panel/LineEdit.text)
	print($Panel/LineEdit2.text)
	var password = $Panel/LineEdit2.text
	print(password.sha256_text())
	password = password.sha256_text()
	password = password.left(10)
	_send("loadmap$" + $Panel/LineEdit.text + "$" + password)
