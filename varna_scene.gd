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

func _set_item(var drug, var state, var stage, var item):
	if (state == "0"):
		item.play("empty_"+drug)
	else:
		match drug:
			"meth":
				if(stage == "1"):
					item.play("done1_"+drug)
				else:
					item.play("done_"+drug)
			"weed":
				item.play("done_"+drug)
			"heroine":
				pass
 
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
	print(OS.get_system_time_secs())
	$varna/textbox.visible = true
	$varna/textbox.text = "You just planted a seed"
	item.play("growing_weed")
	yield(get_tree().create_timer(3.0), "timeout")
	$varna/textbox.visible = false
	yield(get_tree().create_timer(7.0), "timeout")
	item.play("done_weed")
	

func _weedharvest(var i,var grams):
	if tablenumber == null:
		pass
	else:
		items[i].play("empty_weed")
		$varna/textbox.visible = true
		$varna/textbox.text = "You just harvested " + grams + " weed"
		yield(get_tree().create_timer(3.0), "timeout")
		$varna/textbox.visible = false

func _weedstart_weedharvest(var i, var text):
	if (items[i].animation == "done_weed"):
		i+=1
		_send("weedharvest" + text + "$" + varnaID + "$" + String(i))
		firsttime = "n"
	elif (items[i].animation == "empty_weed"):
		i+=1
		$varna.visible = false
		$WeedMinigame.visible = true
		$WeedMinigame/TimerWeed.start()
		firsttime = "n"

func _methstart(var item):
	print(OS.get_system_time_secs())
	$varna/textbox.visible = true
	$varna/textbox.text = "You just started distilling"
	item.play("des_meth")
	yield(get_tree().create_timer(3.0), "timeout")
	$varna/textbox.visible = false
	yield(get_tree().create_timer(7.0), "timeout")
	item.play("done1_meth")

func _methcontinue(var item):
	print(OS.get_system_time_secs())
	$varna/textbox.visible = true
	$varna/textbox.text = "You will have to wait a until it's done"
	item.play("kry_meth")
	yield(get_tree().create_timer(3.0), "timeout")
	$varna/textbox.visible = false
	yield(get_tree().create_timer(7.0), "timeout")
	item.play("done_meth")

func _methharvest(var i,var grams):
	if tablenumber == null:
		pass
	else:
		items[i].play("empty_meth")
		$varna/textbox.visible = true
		$varna/textbox.text = "You just got " + grams + " meth"
		yield(get_tree().create_timer(3.0), "timeout")
		$varna/textbox.visible = false

func _methstart_methharvest(var i, var text):
	if (items[i].animation == "done_meth"):
		i+=1
		_send("methharvest" + text + "$" + varnaID + "$" + String(i))
		firsttime = "n"
	elif (items[i].animation == "done1_meth"):
		i+=1
		$varna.visible = false
		$MethMinigame2.visible = true
		firsttime = "n"
	elif (items[i].animation == "empty_meth"):
		i+=1
		$varna.visible = false
		$MethMinigame.visible = true
		firsttime = "n"

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
						pass
		elif event.scancode == KEY_Q and firsttime == "y":
			user = loadd()
			_get_tablenumber()
			if tablenumber == null:
				pass
			else:
				$varna.visible = false
				$vyber.visible = true
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
	items[tablenumber].play("empty_weed")
	tableitems[tablenumber] = "weed"
	$vyber.visible = false
	$varna.visible = true

func _on_heroin_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$heroin")
	items[tablenumber].play("empty_heroin")
	tableitems[tablenumber] = "heroin"
	$vyber.visible = false
	$varna.visible = true

func _on_meth_pressed():
	_send("changetable" + user + "$" + varnaID + "$" + String(tablenumber+1) + "$meth")
	items[tablenumber].play("empty_meth")
	tableitems[tablenumber] = "meth"
	$vyber.visible = false
	$varna.visible = true 

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
			$MethMinigame/ProgressBar.value = 0
			$MethMinigame.visible = false
			$varna.visible = true

func _on_TimerMeth_timeout():
	if($MethMinigame/ProgressBar.value > 99):
		$MethMinigame/TimerMeth.stop()
	$MethMinigame/ProgressBar.value += 1
	count += 1

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
