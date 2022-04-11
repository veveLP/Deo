extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"
var client = WebSocketClient.new()

var check = false

func _ready():
	var loaded = loadd()
	var x = loaded.split("$")
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
	print("Successful connected")

func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	if payload == "error 0x01":
		print ("cancel login")
		OS.alert("Zadal jsi špatné údaje")
	elif payload == "error 0x06":
		print ("cancel login")
		OS.alert("Tento uživatel je již registrovaný")
	elif payload == "login$successful$true":
		OS.alert("Cílem hry je odemknout všech 13 hoodu")
		OS.alert("Hoody se vám odemknou za respekt který získáte prodáváním drog")
		OS.alert("Věci na vaření a pěstování drog si můžeš koupit v zastavárně")
		OS.alert("Na pěstovní trávy jsou potřeba semínky trávy")
		OS.alert("Na výrobu pika je potřeba: varna, modafen, aceton, diethyl ether, kyselina chlorovodikova, hydroxid sodny, alkohol")
		OS.alert("Na výrobu heroinu je potřeba: vařič, makovice, opium, vápno, čpavek, ocet, chloroform, voda, uhlicitan sodny, aktivni uhli, alkohol ")
		OS.alert("V každám hoodu si můžete najmout 2 z 5 dealerů, kteří za vám potom drogy prodávají")
		print("login succesfull")
		var password = $Panel/LineEdit2.text
		password = password.sha256_text()
		password = password.left(10)
		save("$"+$Panel/LineEdit.text+"$"+password)
		get_tree().change_scene("res://Trebic.tscn")
		if check:
			OS.window_fullscreen = true
		else:
			OS.window_size = Vector2(1920,1080)
	else:
		print("login succesfull")
		var password = $Panel/LineEdit2.text
		password = password.sha256_text()
		password = password.left(10)
		save("$" + $Panel/LineEdit.text + "$" + password)
		get_tree().change_scene("res://Trebic.tscn")
		if check:
			OS.window_fullscreen = true
		else:
			OS.window_size = Vector2(1920,1080)

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

func _on_Button_pressed():
	login()

func _on_CheckBox_toggled(button_pressed):
	if check:
		check = false
	else:
		check = true

func _on_LineEdit2_text_entered(new_text):
	login()

func login():
	var password = $Panel/LineEdit2.text
	password = password.sha256_text()
	password = password.left(10)
	_send("login$" + $Panel/LineEdit.text + "$" + password)	

func _on_Button2_pressed():
	OS.shell_open("https://www.drugempire.online/")
