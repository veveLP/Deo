extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"

var client = WebSocketClient.new()

onready var items = []
var tableitems = []
var tablecount = 0
onready var player = get_node("varna/player")
var varnaID
var user = loadd()

var timer = 0
var count = 0
var pole = [0,0,0,0]
var error = 0
var timestamp = 0
var colors = [1,1,1]	

onready var textbox = get_node("varna/textbox")

func _ready():
	client.connect("connection_closed", self, "_on_connection_closed")
	client.connect("connection_error", self, "_on_connection_closed")
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data")
	
	var err = client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	$varna/textbox.visible = false
	varnaID = $varna/player.scene
	varnaID.erase(0,11)


func _set_sprite_frame(var time, var sprite):
	time*=sprite.get_sprite_frames().get_animation_speed(sprite.get_animation())
	time=sprite.get_sprite_frames().get_frame_count(sprite.get_animation())-time
	sprite.frame = int(time)

func _play_animation(var sprite):
	sprite.playing = true
	while(sprite.get_frame() != sprite.get_sprite_frames().get_frame_count(sprite.get_animation())-1):
		yield(get_tree().create_timer(0.1), "timeout")
	sprite.playing=false

func _set_item(var drug, var state, var stage, var item):
	if (state != "0"):
		match drug:
			"meth":
				if(stage == "1"):
					item.set_animation("des_"+drug)
					if (timestamp > int(state)):
						item.frame = item.get_sprite_frames().get_frame_count(item.get_animation())-1
					else:
						_play_animation(item)
						_set_sprite_frame(int(state)-timestamp,item)
				else:
					item.set_animation("kry_"+drug)
					if (timestamp > int(state)):
						item.frame = item.get_sprite_frames().get_frame_count(item.get_animation())-1
					else:
						_play_animation(item)
						_set_sprite_frame(int(state)-timestamp,item)
			"weed":
				item.set_animation("growing_"+drug)
				if (timestamp > int(state)):
					item.frame = item.get_sprite_frames().get_frame_count(item.get_animation())-1
				else:
					_play_animation(item)
					_set_sprite_frame(int(state)-timestamp,item)
			"heroin":
				if(stage == "1"):
					item.set_animation("cooking1_"+drug)
					if (timestamp > int(state)):
						item.frame = item.get_sprite_frames().get_frame_count(item.get_animation())-1
					else:
						_play_animation(item)
						_set_sprite_frame(int(state)-timestamp,item)
				else:
					item.set_animation("cooking2_"+drug)
					if (timestamp > int(state)):
						item.frame = item.get_sprite_frames().get_frame_count(item.get_animation())-1
					else:
						_play_animation(item)
						_set_sprite_frame(int(state)-timestamp,item)
	else:
		match drug:
			"meth":
				item.set_animation("des_"+drug)
			"weed":
				item.set_animation("growing_"+drug)
			"heroin":
				item.set_animation("cooking1_"+drug)
 
func _get_table_count(var x):
	return (x.size()-2)/3

func _get_tablenumber():
	var body = $varna/player/body.get_overlapping_areas()
	tablenumber = null
	if (body.size()==0):
		pass
	else:
		var table = body[0]
		for i in tablecount+1:
			if(table.name == "table" + String(i)):
				tablenumber = i
				break

func _weedstart(var item):
	$varna/textbox.visible = true
	$varna/textbox.text = "You just planted a seed"
	_play_animation(item)
	yield(get_tree().create_timer(3.0), "timeout")
	$varna/textbox.visible = false

func _weedharvest(var i,var grams):
	if tablenumber == null:
		pass
	else:
		items[i].frame = 0
		$varna/textbox.visible = true
		$varna/textbox.text = "You just harvested " + grams + " weed"
		yield(get_tree().create_timer(3.0), "timeout")
		$varna/textbox.visible = false

func _weedstart_weedharvest(var i, var text):
	if (items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		i+=1
		_send("weedharvest" + text + "$" + varnaID + "$" + String(i))
		firsttime = "n"
	elif (items[i].frame == 0):
		i+=1
		$varna.visible = false
		$WeedMinigame.visible = true
		$WeedMinigame/TimerWeed.start()
		firsttime = "n"

func _methstart(var item):
	$varna/textbox.visible = true
	$varna/textbox.text = "You just started distilling"
	item.set_animation("des_meth")
	_play_animation(item)
	yield(get_tree().create_timer(3.0), "timeout")
	$varna/textbox.visible = false

func _methcontinue(var item):
	$varna/textbox.visible = true
	$varna/textbox.text = "You will have to wait a until it's done"
	item.set_animation("kry_meth")
	_play_animation(item)
	yield(get_tree().create_timer(3.0), "timeout")
	$varna/textbox.visible = false

func _methharvest(var i,var grams):
	if tablenumber == null:
		pass
	else:
		items[i].set_animation("des_meth")
		$varna/textbox.visible = true
		$varna/textbox.text = "You just got " + grams + " meth"
		yield(get_tree().create_timer(3.0), "timeout")
		$varna/textbox.visible = false

func _methstart_methharvest(var i, var text):
	if (items[i].animation == "kry_meth" && items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		i+=1
		_send("methharvest" + text + "$" + varnaID + "$" + String(i))
		firsttime = "n"
	elif (items[i].animation == "des_meth" && items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		i+=1
		$varna.visible = false
		$MethMinigame2.visible = true
		firsttime = "n"
	elif (items[i].animation == "des_meth" && items[i].frame == 0):
		i+=1
		$varna.visible = false
		$MethMinigame.visible = true
		firsttime = "n"

func _heroinstart_heroinharvest(var i, var text):
	if (items[i].animation == "cooking2_heroin" && items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		i+=1
		_send("heroinharvest" + text + "$" + varnaID + "$" + String(i))
		firsttime = "n"
	elif (items[i].animation == "cooking1_heroin" && items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		i+=1
		_send("heroincontinue" + text + "$" + varnaID + "$" + String(i) + "$5")
		firsttime = "n"
	elif (items[i].animation == "cooking1_heroin" && items[i].frame == 0):
		i+=1
		_send("heroinstart" + text + "$" + varnaID + "$" + String(i) + "$5")
		firsttime = "n"

func _heroinstart(var item):
	$varna/textbox.visible = true
	$varna/textbox.text = "You just started cooking, wait until you can add alcohol"
	item.set_animation("cooking1_heroin")
	_play_animation(item)
	yield(get_tree().create_timer(3.0), "timeout")
	$varna/textbox.visible = false

func _heroincontinue(var item):
	$varna/textbox.visible = true
	$varna/textbox.text = "You will have to wait a until it's done"
	item.set_animation("cooking2_heroin")
	_play_animation(item)
	yield(get_tree().create_timer(3.0), "timeout")
	$varna/textbox.visible = false

func _heroinharvest(var i,var grams):
	if tablenumber == null:
		pass
	else:
		items[i].set_animation("cooking1_heroin")
		$varna/textbox.visible = true
		$varna/textbox.text = "You just got " + grams + " heroin"
		yield(get_tree().create_timer(3.0), "timeout")
		$varna/textbox.visible = false

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
	_send("getservertimestamp" + text)
	_send("loadinterior"+ text +"$" + varnaID)
	
func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	var x = payload.split("$")
	match x[0]:
		"weedstart":
			_weedstart(items[tablenumber])
		"weedharvest":
			_weedharvest(tablenumber,x[1])
		"methstart":
			_methstart(items[tablenumber])
		"methcontinue":
			_methcontinue(items[tablenumber])
		"methharvest":
			_methharvest(tablenumber,x[1])
		"heroinstart":
			_heroinstart(items[tablenumber])
		"heroincontinue":
			_heroincontinue(items[tablenumber])
		"heroinharvest":
			_heroinharvest(tablenumber,x[1])
		"loadinterior":
			var m = 1
			var n = 2
			var o = 3
			for i in _get_table_count(x):
				items.append(get_node("varna/table"+ String(i) +"/AnimatedSprite"))
				_set_item(x[m],x[n],x[o],items[i])
				tablecount = i
				tableitems.append(x[m])
				n+=3
				m+=3
				o+=3
		"error", "successful":
			pass
		_:
			timestamp = int(x[0])

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)

var firsttime = "y"
var tablenumber = null

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			_get_tablenumber()
			if tablenumber == null:
				pass
			else:
				match tableitems[tablenumber]:
					"weed":
						_weedstart_weedharvest(tablenumber,loadd())
					"meth":
						_methstart_methharvest(tablenumber,loadd())
					"heroin":
						_heroinstart_heroinharvest(tablenumber,loadd())
		elif event.scancode == KEY_Q and firsttime == "y":
			user = loadd()
			_get_tablenumber()
			if tablenumber == null:
				pass
			else:
				#$varna.visible = false
				$AreaVyber.visible = true
				firsttime = "n"
		else:
			firsttime = "y"

func _on_leave_body_entered(body):
	get_tree().change_scene("res://Trebic.tscn")

func _on_ButtonSelect_pressed():
	$WeedMinigame/TimerWeed.stop()
	var Quantity = 0
	var PBvalue = $WeedMinigame/ProgressBar.value
	var i = tablenumber + 1
	if PBvalue >= 0 && PBvalue < 12 || PBvalue > 88:
		Quantity = 4
	elif PBvalue >= 12 && PBvalue < 23 || PBvalue > 77 && PBvalue <= 88:
		Quantity = 3
	elif PBvalue >= 23 && PBvalue < 34 || PBvalue > 66 && PBvalue <= 77:
		Quantity = 2
	elif PBvalue >= 34 && PBvalue < 45 || PBvalue > 55 && PBvalue <= 66:
		Quantity = 1
	_send("weedstart" + loadd() + "$" + varnaID + "$" + str(i) + "$" + str(Quantity))
	$WeedMinigame/ProgressBar.value = 0
	$WeedMinigame.visible = false
	$varna.visible = true

func _on_TimerWeed_timeout():
	if $WeedMinigame/ProgressBar.value == 100:	
		$WeedMinigame/ProgressBar.value = 0;
	else:
		$WeedMinigame/ProgressBar.value += 5

func _on_weed_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$weed")
	items[tablenumber].set_animation("growing_weed")
	tableitems[tablenumber] = "weed"
	$AreaVyber.visible = false
	#$varna.visible = true

func _on_heroin_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$heroin")
	items[tablenumber].set_animation("cooking1_heroin")
	tableitems[tablenumber] = "heroin"
	$AreaVyber.visible = false
	#$varna.visible = true

func _on_meth_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$meth")
	items[tablenumber].set_animation("des_meth")
	tableitems[tablenumber] = "meth"
	$AreaVyber.visible = false
	#$varna.visible = true 

func _on_Button_button_down():
	if timer < 4:
		$MethMinigame/TimerMeth.start()
		print("fyou")

func _on_Button_button_up():
	$MethMinigame/TimerMeth.stop()
	if timer < 4:
		print("Error: " + str(error))
		pole[timer] = count
		count = 0
		timer += 1
		if timer == 4:
			var Quantity = 5
			var i = tablenumber + 1
			print(str(pole[0]) +","+ str(pole[1]) +","+ str(pole[2]) +","+ str(pole[3]))
			for j in 4:
				error += abs(25-pole[j])
			if(error <= 5):
				Quantity = 0
			elif(error <= 10):
				Quantity = 1
			elif(error <= 15):
				Quantity = 2
			elif(error <= 20):
				Quantity = 3
			elif(error <= 25):
				Quantity = 4
			print("Error: " + str(error))
			print("quantity: " + str(Quantity))
			_send("methstart" + loadd() + "$" + varnaID + "$" + str(i) + "$" + str(Quantity))
			timer = 0
			error = 0
			for j in 3:
				colors[j] = 1
			$MethMinigame/ProgressBar.value = 0
			$MethMinigame.visible = false
			$varna.visible = true

func _on_TimerMeth_timeout():
	if($MethMinigame/ProgressBar.value > 99):
		$MethMinigame/TimerMeth.stop()
	$MethMinigame/ProgressBar.value += 1
	count += 1
	match timer:
		1:
			for i in 2:
				colors[i] -= 0.04
		2:
			colors[1] += 0.04
			colors[2] -= 0.04
		3:
			colors[0] += 0.04
			colors[1] -= 0.04
	for i in 3:
		if colors[i] > 1:
			colors[i] = 1
		elif colors[i] < 0:
			colors[i] = 0
	$MethMinigame/ProgressBar.get("custom_styles/fg").bg_color = Color(colors[0], colors[1], colors[2])

func _on_Button2_button_down():
	$MethMinigame2/TimerMeth2.start()

func _on_Button2_button_up():
	$MethMinigame2/TimerMeth2.stop()
	var i = tablenumber + 1
	var PBvalue = $MethMinigame2/ProgressBar.value
	var Quantity = 0
	if PBvalue >= 0 && PBvalue < 12 || PBvalue > 88:
		Quantity = 4
	elif PBvalue >= 12 && PBvalue < 23 || PBvalue > 77 && PBvalue <= 88:
		Quantity = 3
	elif PBvalue >= 23 && PBvalue < 34 || PBvalue > 66 && PBvalue <= 77:
		Quantity = 2
	elif PBvalue >= 34 && PBvalue < 45 || PBvalue > 55 && PBvalue <= 66:
		Quantity = 1
	print(str(Quantity))
	_send("methcontinue" + loadd() + "$" + varnaID + "$" + str(i) + "$" + str(Quantity))
	$MethMinigame2/ProgressBar.value = 0
	$MethMinigame2.visible = false
	$varna.visible = true

func _on_TimerMeth2_timeout():
	$MethMinigame2/ProgressBar.value += 5
	if $MethMinigame2/ProgressBar.value == 100: $MethMinigame2/TimerMeth2.stop()
