extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"

var client = WebSocketClient.new()

onready var items = []
var tableitems = []
var tablecount = 0
onready var player = get_node("varna/player")
var varnaID
var user = loadd()
var timestamp = 0
var inv = []

var timer = 0
var count = 0
var pole = [0,0,0,0]
var error = 0
var colors = [1,1,1]
var first = true

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
	if ((sprite.animation == "des_meth" || sprite.animation == "growing_meth" || sprite.animation == "cooking1_heroin") && sprite.frame==0):
		sprite.frame=1

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
	if (body.size()!=0):
		var table = body[0]
		for i in tablecount+1:
			if(table.name == "table" + String(i)):
				tablenumber = i
				break

func _weedstart_weedharvest(var i, var text):
	if (items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		_send("weedharvest" + text + "$" + varnaID + "$" + str(i + 1))
		firsttime = "n"
	elif (items[i].frame == 0):
		if int(inv[4]) > 0:
			inv[4] = str(int(inv[4]) - 1)
			$varna.visible = false
			$WeedMinigame.visible = true
			$WeedMinigame/TimerWeed.start()
		else:
			$varna/textbox.visible = true
			$varna/textbox.text = "You don't have ingredients"
			yield(get_tree().create_timer(3.0), "timeout")
			$varna/textbox.visible = false
		firsttime = "n"

func _weedstart(var item):
	$varna/textbox.visible = true
	$varna/textbox.text = "You just planted a seed"
	item.frame = 1
	_play_animation(item)
	yield(get_tree().create_timer(3.0), "timeout")
	$varna/textbox.visible = false

func _weedharvest(var i,var grams):
	if tablenumber != null:
		items[i].frame = 0
		$varna/textbox.visible = true
		$varna/textbox.text = "You just harvested " + grams + " weed"
		yield(get_tree().create_timer(3.0), "timeout")
		$varna/textbox.visible = false

func _methstart_methharvest(var i, var text):
	if (items[i].animation == "kry_meth" && items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		_send("methharvest" + text + "$" + varnaID + "$" + str(i + 1))
		firsttime = "n"
	elif (items[i].animation == "des_meth" && items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		if int(inv[16]) > 0:
			inv[16] = str(int(inv[16]) - 1)
			$varna.visible = false
			$MethMinigame2.visible = true
		else:
			$varna/textbox.visible = true
			$varna/textbox.text = "You don't have ingredients"
			yield(get_tree().create_timer(3.0), "timeout")
			$varna/textbox.visible = false
		firsttime = "n"
	elif (items[i].animation == "des_meth" && items[i].frame == 0):
		var ingr = true
		for i in 5:
			if int(inv[i + 7]) == 0:
				ingr = false
		if ingr:
			for i in 5:
				inv[i + 7] = str(int(inv[i + 7]) - 1)
			$varna.visible = false
			$MethMinigame.visible = true
		else:
			$varna/textbox.visible = true
			$varna/textbox.text = "You don't have ingredients"
			yield(get_tree().create_timer(3.0), "timeout")
			$varna/textbox.visible = false
		firsttime = "n"

func _methstart(var item):
	$varna/textbox.visible = true
	$varna/textbox.text = "You just started distilling"
	item.set_animation("des_meth")
	item.frame = 1
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
	if tablenumber != null:
		items[i].set_animation("des_meth")
		$varna/textbox.visible = true
		$varna/textbox.text = "You just got " + grams + " meth"
		yield(get_tree().create_timer(3.0), "timeout")
		$varna/textbox.visible = false

func _heroinstart_heroinharvest(var i, var text):
	if (items[i].animation == "cooking2_heroin" && items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		_send("heroinharvest" + text + "$" + varnaID + "$" + str(i + 1))
		firsttime = "n"
	elif (items[i].animation == "cooking1_heroin" && items[i].frame == items[i].get_sprite_frames().get_frame_count(items[i].get_animation())-1):
		var ingr = true
		for i in 5:
			if int(inv[i + 13]) == 0:
				ingr = false
		if ingr:
			for i in 5:
				inv[i + 13] = str(int(inv[i + 13]) - 1)
			$varna.visible = false
			$HeroinMinigame2.visible = true
		else:
			$varna/textbox.visible = true
			$varna/textbox.text = "You don't have ingredients"
			yield(get_tree().create_timer(3.0), "timeout")
			$varna/textbox.visible = false
		firsttime = "n"
	elif (items[i].animation == "cooking1_heroin" && items[i].frame == 0):
		var ingr = true
		for i in 3:
			if int(inv[i + 18]) == 0:
				ingr = false
		if ingr:
			for i in 3:
				inv[i + 18] = str(int(inv[i + 18]) - 1)
			$varna.visible = false
			$HeroinMinigame.visible = true
		else:
			$varna/textbox.visible = true
			$varna/textbox.text = "You don't have ingredients"
			yield(get_tree().create_timer(3.0), "timeout")
			$varna/textbox.visible = false
		firsttime = "n"

func _heroinstart(var item):
	$varna/textbox.visible = true
	$varna/textbox.text = "You just started cooking, wait until you can add alcohol"
	item.set_animation("cooking1_heroin")
	item.frame = 1
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
	if tablenumber != null:
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
	_send("loadinterior" + text +"$" + varnaID)
	_send("inventory" + text)
	
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
		"inventory":
			inv = x
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

func _on_weed_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$weed")
	items[tablenumber].set_animation("growing_weed")
	tableitems[tablenumber] = "weed"
	$AreaVyber.visible = false

func _on_meth_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$meth")
	items[tablenumber].set_animation("des_meth")
	tableitems[tablenumber] = "meth"
	$AreaVyber.visible = false

func _on_heroin_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$heroin")
	items[tablenumber].set_animation("cooking1_heroin")
	tableitems[tablenumber] = "heroin"
	$AreaVyber.visible = false

func _on_ButtonWeed_pressed():
	$WeedMinigame/TimerWeed.stop()
	var Quantity = 0
	var PBvalue = $WeedMinigame/ProgressBar.value
	if PBvalue >= 0 && PBvalue < 12 || PBvalue > 88:
		Quantity = 4
	elif PBvalue >= 12 && PBvalue < 23 || PBvalue > 77 && PBvalue <= 88:
		Quantity = 3
	elif PBvalue >= 23 && PBvalue < 34 || PBvalue > 66 && PBvalue <= 77:
		Quantity = 2
	elif PBvalue >= 34 && PBvalue < 45 || PBvalue > 55 && PBvalue <= 66:
		Quantity = 1
	print("Quantity: " + str(Quantity))
	_send("weedstart" + loadd() + "$" + varnaID + "$" + str(tablenumber + 1) + "$" + str(Quantity))
	$WeedMinigame/ProgressBar.value = 0
	$WeedMinigame.visible = false
	$varna.visible = true

func _on_TimerWeed_timeout():
	if $WeedMinigame/ProgressBar.value == 100:	
		$WeedMinigame/ProgressBar.value = 0;
	else:
		$WeedMinigame/ProgressBar.value += 5

func _on_ButtonMeth_button_down():
	if timer < 4:
		$MethMinigame/TimerMeth.start()

func _on_ButtonMeth_button_up():
	$MethMinigame/TimerMeth.stop()
	pole[timer] = count
	count = 0
	timer += 1
	if timer == 4:
		var Quantity = 5
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
		print(str(pole[0]) +","+ str(pole[1]) +","+ str(pole[2]) +","+ str(pole[3]))
		print("Error: " + str(error))
		print("Quantity: " + str(Quantity))
		_send("methstart" + loadd() + "$" + varnaID + "$" + str(tablenumber + 1) + "$" + str(Quantity))
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

func _on_ButtonMeth2_button_down():
	$MethMinigame2/TimerMeth2.start()

func _on_ButtonMeth2_button_up():
	$MethMinigame2/TimerMeth2.stop()
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
	print("Quantity: " + str(Quantity))
	_send("methcontinue" + loadd() + "$" + varnaID + "$" + str(tablenumber + 1) + "$" + str(Quantity))
	$MethMinigame2/ProgressBar.value = 0
	$MethMinigame2.visible = false
	$varna.visible = true

func _on_TimerMeth2_timeout():
	$MethMinigame2/ProgressBar.value += 5
	if $MethMinigame2/ProgressBar.value == 100: $MethMinigame2/TimerMeth2.stop()

func _on_ButtonHeroin_pressed():
	if first:
		if timer < 3:
			$HeroinMinigame/TimerHeroinTick.start()
			$HeroinMinigame/TimerHeroin.start()
			first = false
	else:
		$HeroinMinigame/ProgressBar.value += 10

func _on_TimerHeroinTick_timeout():
	$HeroinMinigame/ProgressBar.value -= 1
	$HeroinMinigame/Time.text = str(float($HeroinMinigame/Time.text.split(' ')[0]) - 0.05) + " s"

func _on_TimerHeroin_timeout():
	$HeroinMinigame/TimerHeroinTick.stop()
	$HeroinMinigame/Time.text = "3.00 s"
	var PBvalue = $HeroinMinigame/ProgressBar.value
	$HeroinMinigame/ProgressBar.value = 0
	if PBvalue >= 0 && PBvalue < 12 || PBvalue > 88:
		error += 4
	elif PBvalue >= 12 && PBvalue < 23 || PBvalue > 77 && PBvalue <= 88:
		error += 3
	elif PBvalue >= 23 && PBvalue < 34 || PBvalue > 66 && PBvalue <= 77:
		error += 2
	elif PBvalue >= 34 && PBvalue < 45 || PBvalue > 55 && PBvalue <= 66:
		error += 1
	first = true
	timer += 1
	if timer == 3:
		print("Quality: " + str(round(float(error) / 3)))
		_send("heroinstart" + loadd() + "$" + varnaID + "$" + str(tablenumber + 1) + "$" + str(round(float(error) / 3)))
		timer = 0
		error = 0
		$HeroinMinigame.visible = false
		$varna.visible = true

func _on_ButtonHeroinIngredient1_pressed():
	timer += 1
	if timer != 1:
		error += 1
	if timer == 4:
		_HeroinMinigame2()

func _on_ButtonHeroinIngredient2_pressed():
	if timer != 2:
		error += 1
		print("Error2:" + str(error))
	if timer == 4:
		_HeroinMinigame2()
	timer += 1

func _on_ButtonHeroinIngredient3_pressed():
	timer += 1
	if timer != 3:
		error += 1
	if timer == 4:
		_HeroinMinigame2()

func _on_ButtonHeroinIngredient4_pressed():
	timer += 1
	if timer != 4:
		error += 1
	if timer == 4:
		_HeroinMinigame2()

func _HeroinMinigame2():
	var Quantity
	print("Error: " + str(error))
	if error == 3 || error == 4:
		Quantity = error
	else:
		Quantity = error - 1
	print("Quantity: " + str(Quantity))
	_send("heroincontinue" + loadd() + "$" + varnaID + "$" + str(tablenumber + 1) + "$" + str(Quantity))
	error = 0
	timer = 0
	$HeroinMinigame2.visible = false
	$varna.visible = true
