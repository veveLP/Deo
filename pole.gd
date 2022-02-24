extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"
var client = WebSocketClient.new()

var check = false
var error = 0

var unlocked
var fieldnumber = null
var fieldcount = 32
var fieldsprites = [0]
var firsttime = "y"
var fieldlvl

func _ready():
	client.connect("connection_closed", self, "_on_connection_closed")
	client.connect("connection_error", self, "_on_connection_closed")
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data")
	var err = client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	_gen_fieldsprites()
	for i in 32:
		fieldsprites[i+1].frame = 71

func _process(delta):
	client.poll()

func _on_connection_closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

var text = loadd()
var timestamp

func _on_connected(proto = ""):
	var text = loadd()
	print("Connected with protocol: ", proto)
	_send("loadpole" + text)
	_send("inventory" + text)
	_send("money" + text)

func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	var x = payload.split("$")
	match x[0]:
		"loadpole":
			fieldlvl = x[1]
			_loadpole()
		"loadsektorpole":
			for i in unlocked:
				if int(x[i+1]) < timestamp:
					fieldsprites[i + 1].frame = fieldsprites[i + 1].get_sprite_frames().get_frame_count(fieldsprites[i + 1].get_animation())-1
				else:
					_set_sprite_frame(int(x[i + 1]) - timestamp, fieldsprites[i + 1])
		"makoviceharvest":
			fieldsprites[fieldnumber].frame = 0
			_grow_field(fieldsprites[fieldnumber])
		"error", "successful":
			pass
		"getservertimestamp":
			timestamp = int(x[1])
		"inventory":
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
		"money":
			$LabelMoney.text = x[1]
		"poleupgrade":
			if x[1] == "successful":
				fieldlvl = str(int(fieldlvl) + 1)
				match fieldlvl:
					"1":
						$FieldUpgr/Panel/LabelMoney.text = "500"
					"2":
						$FieldUpgr/Panel/LabelMoney.text = "1250"
					"3":
						$FieldUpgr/Panel/LabelMoney.text = "2500"
					"4":
						$FieldUpgr/Panel/LabelMoney.text = "5000"
					"5":
						$FieldUpgr/Panel/LabelInfo.text	= "Už máš koupené všechna pole!!"
						$FieldUpgr/Panel/LabelMoney.text = ""
						$FieldUpgr/Panel/FieldUpgrade.disabled = true
				_send("money" + text)
				match fieldlvl:
					"2":
						$TileMap2.set_cell(13,13,12)
					"3":
						$TileMap2.set_cell(13,13,12)
						$TileMap2.set_cell(10,9,11)
					"4":
						$TileMap2.set_cell(13,13,12)
						$TileMap2.set_cell(10,9,11)
						$TileMap2.set_cell(13,7,12)
						$TileMap2.set_cell(16,9,16)
						$TileMap2.set_cell(17,9,15)
					"5":
						$TileMap2.set_cell(13,13,12)
						$TileMap2.set_cell(10,9,11)
						$TileMap2.set_cell(13,7,12)
						$TileMap2.set_cell(16,9,16)
						$TileMap2.set_cell(17,9,15)
						$TileMap2.set_cell(22,6,12)
						$TileMap2.set_cell(22,13,12)

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

func _on_leave_body_entered(body):
	get_tree().change_scene("res://Trebic.tscn")

func _on_ButtonInv_pressed():
	_send("inventory" + loadd())
	$Iv.visible = true

func _on_ButtonInvExit_pressed():
	$Iv.visible = false

func _set_sprite_frame(var time, var sprite):
	time *= sprite.get_sprite_frames().get_animation_speed(sprite.get_animation())
	time = sprite.get_sprite_frames().get_frame_count(sprite.get_animation()) - time
	sprite.frame = int(time)

func _loadpole():
	match fieldlvl:
		"1":
			unlocked=2
		"2":
			$TileMap2.set_cell(13,13,12)
			unlocked=6
		"3":
			$TileMap2.set_cell(13,13,12)
			$TileMap2.set_cell(10,9,11)
			unlocked=12
		"4":
			$TileMap2.set_cell(13,13,12)
			$TileMap2.set_cell(10,9,11)
			$TileMap2.set_cell(13,7,12)
			$TileMap2.set_cell(16,9,16)
			$TileMap2.set_cell(17,9,15)
			unlocked=20
		"5":
			$TileMap2.set_cell(13,13,12)
			$TileMap2.set_cell(10,9,11)
			$TileMap2.set_cell(13,7,12)
			$TileMap2.set_cell(16,9,16)
			$TileMap2.set_cell(17,9,15)
			$TileMap2.set_cell(22,6,12)
			$TileMap2.set_cell(22,13,12)
			unlocked=32
	for i in unlocked:
		_grow_field(fieldsprites[i + 1])
	_send("getservertimestamp" + text)
	_send("loadsektorpole" + text + "$" + fieldlvl)

func _gen_fieldsprites():
	for i in 32:
		match i+1:
			1, 2:
				fieldsprites.append(get_node("Pole1/slot" + str(i + 1) + "/AnimatedSprite"))
			3, 4, 5, 6:
				fieldsprites.append(get_node("Pole2/slot" + str(i + 1) + "/AnimatedSprite"))
			7, 8, 9, 10, 11, 12:
				fieldsprites.append(get_node("Pole3/slot" + str(i + 1) + "/AnimatedSprite"))
			13, 14, 15, 16, 17, 18, 19, 20:
				fieldsprites.append(get_node("Pole4/slot" + str(i + 1) + "/AnimatedSprite"))
			21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32:
				fieldsprites.append(get_node("Pole5/slot" + str(i + 1) + "/AnimatedSprite"))

func _grow_field(var x):
	x.playing = true
	while(x.get_frame() != x.get_sprite_frames().get_frame_count(x.get_animation()) - 1):
		yield(get_tree().create_timer(2), "timeout")
	x.playing = false

func _get_fieldnumber():
	var body = $player/body.get_overlapping_areas()
	fieldnumber = null
	if body.size() == 0:
		pass
	else:
		var field = body[0]
		for i in fieldcount + 1:
			if(field.name == "slot" + str(i)):
				fieldnumber = i
				break

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			firsttime = "n"
			if $Albanec.overlaps_body($player):
				match fieldlvl:
					"1":
						$FieldUpgr/Panel/LabelMoney.text = "500"
					"2":
						$FieldUpgr/Panel/LabelMoney.text = "1250"
					"3":
						$FieldUpgr/Panel/LabelMoney.text = "2500"
					"4":
						$FieldUpgr/Panel/LabelMoney.text = "5000"
					"5":
						$FieldUpgr/Panel/LabelInfo.text	= "Už máš koupené všechna pole!!"
						$FieldUpgr/Panel/LabelMoney.text = ""
						$FieldUpgr/Panel/FieldUpgrade.disabled = true
				$FieldUpgr.visible = true
			else:
				_get_fieldnumber()
				if fieldnumber != null:
					if fieldsprites[fieldnumber].get_frame() == fieldsprites[fieldnumber].get_sprite_frames().get_frame_count(fieldsprites[fieldnumber].get_animation()) - 1:
						_send("makoviceharvest" + text + "$" + str(fieldnumber))
		else:
			firsttime = "y"

func _on_FieldUpgrade_pressed():
	var price
	match fieldlvl:
		"1":
			price = 500
		"2":
			price = 1250
		"3":
			price = 2500
		"4":
			price = 5000
	if int($LabelMoney.text) >= price:
		_send("poleupgrade" + loadd())
func _on_FieldExit_pressed():
	$FieldUpgr.visible = false
