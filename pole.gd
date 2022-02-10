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
	_gen_fieldsprites()

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
	_send("loadpole" +text)
	
func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	var x = payload.split("$")
	match x[0]:
		"loadpole":
			_loadpole(x[1])
		"loadsektorpole":
			for i in unlocked:
				if(int(x[i+1])<timestamp):
					fieldsprites[i+1].frame = fieldsprites[i+1].get_sprite_frames().get_frame_count(fieldsprites[i+1].get_animation())-1
				else:
					_set_sprite_frame(int(x[i+1])-timestamp,fieldsprites[i+1])
		"makoviceharvest":
			fieldsprites[fieldnumber].frame = 0
			_grow_field(fieldsprites[fieldnumber])
		"error", "successful":
			pass
		_:
			timestamp = int(x[0])

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
var error = 0

# Called when the node enters the scene tree for the first time.


func _on_leave_body_exited(body):
	get_tree().change_scene("res://Trebic.tscn")
	
var unlocked
var fieldnumber = null
var fieldcount = 32
var fieldsprites = [0]
var firsttime = "y"

func _set_sprite_frame(var time, var sprite):
	time*=sprite.get_sprite_frames().get_animation_speed(sprite.get_animation())
	time=sprite.get_sprite_frames().get_frame_count(sprite.get_animation())-time
	sprite.frame = int(time)

func _loadpole(var level):
	match level:
		"1":
			unlocked=2
		"2":
			unlocked=6
		"3":
			unlocked=12
		"4":
			unlocked=20
		"5":
			unlocked=32
	for i in unlocked:
		_grow_field(fieldsprites[i+1])
	_send("getservertimestamp" + text)
	_send("loadsektorpole" + text + "$" + level)

func _gen_fieldsprites():
	for i in 32:
		match i+1:
			1, 2:
				fieldsprites.append(get_node("Pole1/slot"+ String(i+1) +"/AnimatedSprite"))
			3, 4, 5, 6:
				fieldsprites.append(get_node("Pole2/slot"+ String(i+1) +"/AnimatedSprite"))
			7, 8, 9, 10, 11, 12:
				fieldsprites.append(get_node("Pole3/slot"+ String(i+1) +"/AnimatedSprite"))
			13, 14, 15, 16, 17, 18, 19, 20:
				fieldsprites.append(get_node("Pole4/slot"+ String(i+1) +"/AnimatedSprite"))
			21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32:
				fieldsprites.append(get_node("Pole5/slot"+ String(i+1) +"/AnimatedSprite"))

func _grow_field(var x):
	x.playing = true
	while(x.get_frame() != x.get_sprite_frames().get_frame_count(x.get_animation())-1):
		yield(get_tree().create_timer(2), "timeout")
	x.playing=false

func _get_fieldnumber():
	var body = $player/body.get_overlapping_areas()
	fieldnumber = null
	if (body.size()==0):
		pass
	else:
		var field = body[0]
		for i in fieldcount+1:
			if(field.name == "slot" + String(i)):
				fieldnumber = i
				break


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			firsttime = "n"
			_get_fieldnumber()
			if fieldnumber != null:
				if fieldsprites[fieldnumber].get_frame()==fieldsprites[fieldnumber].get_sprite_frames().get_frame_count(fieldsprites[fieldnumber].get_animation())-1:
					_send("makoviceharvest" + text + "$" + String(fieldnumber))
		else:
			firsttime = "y"
