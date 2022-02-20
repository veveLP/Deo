extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"
var client = WebSocketClient.new()

var user = loadd()
var firsttime = "y"

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
		$Iv/Inv/AlkoholText.text = x[16]
		$Iv/Inv/OcetText.text = x[17]
		$Iv/Inv/CpavekText.text = x[18]
		$Iv/Inv/VapnoText.text = x[19]

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			
			if $semen.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "100"
				$SelectBody/SelectPanel/ItemID.text = "1"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $hnuj.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "50"
				$SelectBody/SelectPanel/ItemID.text = "2"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $varna.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "4000"
				$SelectBody/SelectPanel/ItemID.text = "3"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $aceton.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "100"
				$SelectBody/SelectPanel/ItemID.text = "4"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $hydroxid.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "80"
				$SelectBody/SelectPanel/ItemID.text = "5"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $kyselina.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "95"
				$SelectBody/SelectPanel/ItemID.text = "6"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $ether.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "370"
				$SelectBody/SelectPanel/ItemID.text = "7"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $varic.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "1000"
				$SelectBody/SelectPanel/ItemID.text = "9"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $chloroform.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "120"
				$SelectBody/SelectPanel/ItemID.text = "10"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $uhlicitan.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "50"
				$SelectBody/SelectPanel/ItemID.text = "11"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $alkohol.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "100"
				$SelectBody/SelectPanel/ItemID.text = "13"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $ocet.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "15"
				$SelectBody/SelectPanel/ItemID.text = "14"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $cpavek.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "600"
				$SelectBody/SelectPanel/ItemID.text = "15"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
			if $vapno.overlaps_body($player):
				$SelectBody.visible = true
				$SelectBody/SelectPanel/ItemPrice.text = "80"
				$SelectBody/SelectPanel/ItemID.text = "16"
				$SelectBody/SelectPanel/LabelPrice.text = "Cena: " + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))
		else:
			firsttime = "y"

func _on_leave_body_entered(body):
	get_tree().change_scene("res://Trebic.tscn")

func _on_ButtonPlus_pressed():
	if $SelectBody/SelectPanel/HSlider.value < 100:
		$SelectBody/SelectPanel/BuyAmount.text = str($SelectBody/SelectPanel/HSlider.value)
		$SelectBody/SelectPanel/HSlider.value = $SelectBody/SelectPanel/HSlider.value + 1

func _on_ButtonMinus_pressed():
	if $SelectBody/SelectPanel/HSlider.value > 1:
		$SelectBody/SelectPanel/BuyAmount.text = str($SelectBody/SelectPanel/HSlider.value)
		$SelectBody/SelectPanel/HSlider.value = $SelectBody/SelectPanel/HSlider.value - 1

func _on_ButtonBuy_pressed():
	var text = loadd()
	for n in $SelectBody/SelectPanel/HSlider.value:
		_send("buy" + user + "$" + $SelectBody/SelectPanel/ItemID.text)
	$SelectBody.visible = false;
	_send("loadmap" + text)

func _on_ButtonCancel_pressed():
	$SelectBody.visible = false;

func _on_HSlider_value_changed(value):
	$SelectBody/SelectPanel/BuyAmount.text = str($SelectBody/SelectPanel/HSlider.value)
	$SelectBody/SelectPanel/LabelPrice.text = "Cena:" + str(int($SelectBody/SelectPanel/ItemPrice.text) * int($SelectBody/SelectPanel/BuyAmount.text))

func _on_ButtonInv_pressed():
	var text = loadd()
	_send("inventory" + text)
	$Iv.visible = true

func _on_ButtonInvExit_pressed():
	$Iv.visible = false
