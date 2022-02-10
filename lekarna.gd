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
	var text = loadd()
	print("Connected with protocol: ", proto)
	_send("loadmap" + text)
	
func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	var x = payload.split("$")
	if (x[0] == "loadmap"):
		$LabelMoney.text = x[2]
	if (x[0] == "inventory"):
		$Iv/Inv/RichTextLabel.bbcode_text = "[center]" + x[1] + "[/center]"
		$Iv/Inv/RichTextLabel2.bbcode_text = "[center]" + x[2] + "[/center]"
		$Iv/Inv/RichTextLabel3.bbcode_text = "[center]" + x[3] + "[/center]"
		$Iv/Inv/SeminkoText.text = x[4]
		$Iv/Inv/HnujText.text = "level: " + x[5]
		$Iv/Inv/VarnaText.text = x[6]
		$Iv/Inv/AcetonText.text = x[7]
		$Iv/Inv/HydroxidText.text = x[8]
		$Iv/Inv/KyselinaText.text = x[9]
		$Iv/Inv/EtherText.text = x[10]
		$Iv/Inv/EfedrinText.text = x[11]
		$Iv/Inv/VaricText.text = x[12]
		$Iv/Inv/ChloroformText.text = x[13]
		$Iv/Inv/UhlicitanText.text = x[14]
		$Iv/Inv/UhliText.text = x[15]
		$Iv/Inv/AlkoholText.text = x[16]
		$Iv/Inv/OcetText.text = x[17]
		$Iv/Inv/CpavekText.text = x[18]
		$Iv/Inv/VapnoText.text = x[19]
		$Iv/Inv/MakoviceText.text = x[20]

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)

var firsttime = "y"

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			if ($lekarna/Prodavac.overlaps_body($lekarna/player)):
				$lekarna.visible=false
				$NabidkaPanel.visible=true
				firsttime = "n"
		else:
			firsttime = "y"

func _on_leave_body_entered(body):
	get_tree().change_scene("res://Trebic.tscn")

var select_id

func _on_ButtonModafen_pressed():
	$SelectPanel/ItemPrice.text = "2000"
	$SelectPanel/ItemID.text = "8"
	$SelectPanel/LabelPrice.text = "Cena:" + str(int($SelectPanel/ItemPrice.text) * int($SelectPanel/BuyAmount.text))
	$SelectPanel.visible = true;


func _on_HSlider_value_changed(value):
	$SelectPanel/BuyAmount.text = str($SelectPanel/HSlider.value)
	$SelectPanel/LabelPrice.text = "Cena:" + str(int($SelectPanel/ItemPrice.text) * int($SelectPanel/BuyAmount.text))

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
		_send("buy"+text+"$"+str($SelectPanel/ItemID.text))
	$SelectPanel.visible = false;
	_send("loadmap" + text)
	
func _on_ButtonExit_pressed():
	$NabidkaPanel.visible = false
	$lekarna.visible = true;


func _on_ButtonInv_pressed():
	var text = loadd()
	_send("inventory" + text)
	$Iv.visible = true


func _on_ButtonInvExit_pressed():
	$Iv.visible = false



func _on_ButtonAktivniUhli_pressed():
	$SelectPanel/ItemPrice.text = "150"
	$SelectPanel/ItemID.text = "12"
	$SelectPanel/LabelPrice.text = "Cena:" + str(int($SelectPanel/ItemPrice.text) * int($SelectPanel/BuyAmount.text))
	$SelectPanel.visible = true;
