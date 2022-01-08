extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"

var client = WebSocketClient.new()

func _ready():
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

var user = loadd()

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
	print("Connected with protocol: ", proto)
	
func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	var x = payload.split("$")

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)

var firsttime = "y"

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			if ($lekarna/Prodavac.overlaps_body($lekarna/player)):
				
				
				firsttime = "n"
		else:
			firsttime = "y"

func _on_leave_body_entered(body):
	get_tree().change_scene("res://Trebic.tscn")


func _on_ButtonModafen_pressed():
	$SelectPanel.visible = true;



func _on_HSlider_value_changed(value):
	$SelectPanel/BuyAmount.text = str($SelectPanel/HSlider.value)


func _on_ButtonPlus_pressed():
	if $SelectPanel/HSlider.value < 100:
		$SelectPanel/BuyAmount.text = str($SelectPanel/HSlider.value)
		$SelectPanel/HSlider.value = int($SelectPanel/HSlider.value+1)
		


func _on_ButtonMinus_pressed():
	if $SelectPanel/HSlider.value > 1:
		$SelectPanel/BuyAmount.text = str($SelectPanel/HSlider.value)
		$SelectPanel/HSlider.value = $SelectPanel/HSlider.value-1
		


func _on_ButtonCancel_pressed():
	$SelectPanel.visible = false;


func _on_ButtonBuy_pressed():
	var text = loadd()
	for n in $SelectPanel/HSlider.value:
		_send("buy"+text+"$8")
	$SelectPanel.visible = false;
