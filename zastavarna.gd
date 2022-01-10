extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var SOCKET_URL = "ws://194.15.112.30:6988"

var client = WebSocketClient.new()

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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var firsttime = "y"

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			if ($semen.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "1"
			if ($hnuj.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "2"
			if ($varna.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "3"
			if ($aceton.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "4"
			if ($hydroxid.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "5"
			if ($kyselina.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "6"
			if ($ether.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "7"
			if ($varic.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "9"
			if ($chloroform.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "10"
			if ($uhlicitan.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "11"
			if ($alkohol.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "13"
			if ($ocet.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "14"
			if ($cpavek.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "15"
			if ($vapno.overlaps_body($player)):
				$SelectBody.visible=true
				$SelectBody/SelectPanel/ItemID.text = "16"
		else:
			firsttime = "y"

func _on_leave_body_entered(body):
	get_tree().change_scene("res://Trebic.tscn") # Replace with function body.



func _on_ButtonPlus_pressed():
	if $SelectBody/SelectPanel/HSlider.value < 100:
		$SelectBody/SelectPanel/BuyAmount.text = str($SelectBody/SelectPanel/HSlider.value)
		$SelectBody/SelectPanel/HSlider.value = int($SelectBody/SelectPanel/HSlider.value+1)


func _on_ButtonMinus_pressed():
	if $SelectBody/SelectPanel/HSlider.value > 1:
		$SelectBody/SelectPanel/BuyAmount.text = str($SelectBody/SelectPanel/HSlider.value)
		$SelectBody/SelectPanel/HSlider.value = $SelectBody/SelectPanel/HSlider.value-1


func _on_ButtonBuy_pressed():
	for n in $SelectBody/SelectPanel/HSlider.value:
		_send("buy"+user+"$" + $SelectBody/SelectPanel/ItemID.text)
	$SelectBody.visible = false;


func _on_ButtonCancel_pressed():
	$SelectBody.visible = false;


func _on_HSlider_value_changed(value):
	$SelectBody/SelectPanel/BuyAmount.text = str($SelectBody/SelectPanel/HSlider.value)
