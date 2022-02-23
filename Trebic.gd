extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"
var client = WebSocketClient.new()
var unlockedHoods = 1

var text = loadd()
var time = [null,null,null,null]
var collect = [false, false]

var TimeStampID
var TimeStamp

func _ready():
	#$HoodPannel/Dealer1/Pico.texture = load("res://assets/money.png")
	$HoodPannel.visible = false
	$Inv.visible = false
	client.connect("connection_closed", self, "_on_connection_closed")
	client.connect("connection_error", self, "_on_connection_closed")
	client.connect("connection_established", self, "_on_connected")
	client.connect("data_received", self, "_on_data")
	var err = client.connect_to_url(SOCKET_URL)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func loadd():
	var file = File.new()
	file.open("res://save_game.dat", File.READ)
	var content = file.get_line()
	file.close()
	return content

func _process(delta):
	client.poll()

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
		unlockedHoods = x[1] 
		$Trebic/UnlockedHoods.text = str(unlockedHoods)
		var test=float(x[3])
		var numb = float(0)
		while float(test) > 1000:
			test = test / 1000
			numb+=1
		var text = ""
		if numb == 1:
			text = "K"
		if numb == 2:
			text = "M"
		if numb == 3:
			text = "B"
		if numb == 4:
			text = "T"
		$LabelRespekt.bbcode_text = "[center]Respekt: " + str(stepify(test,0.1)) +text+ "[/center]"
	if (x[0] == "hood"):
		$HoodPannel/Dealer1/Name.visible = true
		$HoodPannel/Dealer1/Drug1.visible = true
		$HoodPannel/Dealer1/Drug2.visible = true
		$HoodPannel/Dealer1/PoliceChance.visible = true
		$HoodPannel/Dealer1/SellingAmount.visible = true
		$HoodPannel/Dealer1/ProfitCut.visible = true
		$HoodPannel/Dealer2/Name.visible = true
		$HoodPannel/Dealer2/Drug1.visible = true
		$HoodPannel/Dealer2/Drug2.visible = true
		$HoodPannel/Dealer2/PoliceChance.visible = true
		$HoodPannel/Dealer2/SellingAmount.visible = true
		$HoodPannel/Dealer2/ProfitCut.visible = true
		#$HoodPannel/Dealer1/Dealer1.disabled = true
		var fileJSON = File.new()
		fileJSON.open("res://assets/dealeri.json", fileJSON.READ)
		var json= fileJSON.get_as_text()
		var json_result = JSON.parse(json).result
		fileJSON.close()
		if x[7] == str(0):
			$HoodPannel/Dealer1/Name.visible = false
			$HoodPannel/Dealer1/Drug1.visible = false
			$HoodPannel/Dealer1/Drug2.visible = false
			$HoodPannel/Dealer1/PoliceChance.visible = false
			$HoodPannel/Dealer1/SellingAmount.visible = false
			$HoodPannel/Dealer1/ProfitCut.visible = false
			$HoodPannel/Dealer1/Dealer1.icon = load("res://assets/none.png") 
		else:
			match (json_result[x[9]][x[7]]["drugs"][0]):
				"weed": 
					print("weed")
					$HoodPannel/Dealer1/Drug1.icon = load("res://assets/weed.png") 
					$HoodPannel/Dealer1/Drug1.text = "weed"
				"meth": 
					print("meth") 
					$HoodPannel/Dealer1/Drug1.icon = load("res://assets/pico.png") 
					$HoodPannel/Dealer1/Drug1.text = "meth"
				"heroin": 
					print("heroin") 
					$HoodPannel/Dealer1/Drug1.icon = load("res://assets/herion.png") 
					$HoodPannel/Dealer1/Drug1.text = "heroin"
			$HoodPannel/Dealer1/ProfitCut.text = "Podíl ze zisku: "+str(json_result[x[9]][x[7]]["profit_cut"])
			$HoodPannel/Dealer1/PoliceChance.text = "Šance na chycení: "+str(json_result[x[9]][x[7]]["police_chance"])
			$HoodPannel/Dealer1/SellingAmount.text = "Max množství: "+str(json_result[x[9]][x[7]]["selling_amount"])
			$HoodPannel/Dealer1/Name.bbcode_text = ("[center]"+json_result[x[9]][x[7]]["name"])
			$HoodPannel/Dealer1/Dealer1.icon = load("res://assets/"+x[9]+x[7]+".png")
			match (json_result[x[9]][x[7]]["drugs"][1]):
				"weed": 
					print("weed")
					$HoodPannel/Dealer1/Drug2.icon = load("res://assets/weed.png") 
					$HoodPannel/Dealer1/Drug2.text = "weed"
				"meth": 
					print("meth") 
					$HoodPannel/Dealer1/Drug2.icon = load("res://assets/pico.png") 
					$HoodPannel/Dealer1/Drug2.text = "meth"
				"heroin": 
					print("heroin") 
					$HoodPannel/Dealer1/Drug2.icon = load("res://assets/herion.png") 
					$HoodPannel/Dealer1/Drug2.text = "heroin"
		if x[8] == str(0):
			$HoodPannel/Dealer2/Name.visible = false
			$HoodPannel/Dealer2/Drug1.visible = false
			$HoodPannel/Dealer2/Drug2.visible = false
			$HoodPannel/Dealer2/PoliceChance.visible = false
			$HoodPannel/Dealer2/SellingAmount.visible = false
			$HoodPannel/Dealer2/ProfitCut.visible = false
			$HoodPannel/Dealer2/Dealer2.icon = load("res://assets/none.png") 
		else:
			$HoodPannel/Dealer2/ProfitCut.text = "Podíl ze zisku: "+str(json_result[x[9]][x[8]]["profit_cut"])
			$HoodPannel/Dealer2/PoliceChance.text = "Šance na chycení: "+str(json_result[x[9]][x[8]]["police_chance"])
			$HoodPannel/Dealer2/SellingAmount.text = "Max množství: "+str(json_result[x[9]][x[8]]["selling_amount"])
			$HoodPannel/Dealer2/Name.bbcode_text = ("[center]"+json_result[x[9]][x[8]]["name"])
			$HoodPannel/Dealer2/Dealer2.icon = load("res://assets/"+x[9]+x[8]+".png")
			match (json_result[x[9]][x[8]]["drugs"][0]):
				"weed": 
					print("weed")
					$HoodPannel/Dealer2/Drug1.icon = load("res://assets/weed.png") 
					$HoodPannel/Dealer2/Drug1.text = "weed"
				"meth": 
					print("meth") 
					$HoodPannel/Dealer2/Drug1.icon = load("res://assets/pico.png") 
					$HoodPannel/Dealer2/Drug1.text = "meth"
				"heroin": 
					print("heroin") 
					$HoodPannel/Dealer2/Drug1.icon = load("res://assets/herion.png")
					$HoodPannel/Dealer2/Drug1.text = "heroin" 
			match (json_result[x[9]][x[8]]["drugs"][1]):
				"weed": 
					print("weed")
					$HoodPannel/Dealer2/Drug2.icon = load("res://assets/weed.png") 
					$HoodPannel/Dealer2/Drug2.text = "weed"
				"meth": 
					print("meth") 
					$HoodPannel/Dealer2/Drug2.icon = load("res://assets/pico.png") 
					$HoodPannel/Dealer2/Drug2.text = "meth"
				"heroin": 
					print("heroin") 
					$HoodPannel/Dealer2/Drug2.icon = load("res://assets/herion.png") 
					$HoodPannel/Dealer2/Drug2.text = "heroin"
		$HoodPannel/UpperPanel/PopWeedValue.text = x[1]
		$HoodPannel/UpperPanel/PriceWeedValue.text = x[2]
		$HoodPannel/UpperPanel/PopPikoValue.text = x[3]
		$HoodPannel/UpperPanel/PricePikoValue.text = x[4]
		$HoodPannel/UpperPanel/PopHeroinValue.text = x[5]
		$HoodPannel/UpperPanel/PriceHeroinValue.text = x[6]
	if(x[0] == "showdealers"):
		var fileJSON = File.new()
		fileJSON.open("res://assets/dealeri.json", fileJSON.READ)
		var json= fileJSON.get_as_text()
		var json_result = JSON.parse(json).result
		fileJSON.close()
		print (x[1] + "," + x[2] + "," + x[3] + "," + x[4])
		match (json_result[x[4]][x[1]]["drugs"][0]):
				"weed": 
					print("weed")
					$DealerVyber/Dealer1/Drug1.texture = load("res://assets/weed.png") 
				"meth": 
					print("meth") 
					$DealerVyber/Dealer1/Drug1.texture = load("res://assets/pico.png") 
				"heroin": 
					print("heroin") 
					$DealerVyber/Dealer1/Drug1.texture = load("res://assets/herion.png") 
		$DealerVyber/Dealer1/ProfitCut.text = str(json_result[x[4]][x[1]]["profit_cut"])
		$DealerVyber/Dealer1/PoliceChance.text = str(json_result[x[4]][x[1]]["police_chance"])
		$DealerVyber/Dealer1/SellingAmount.text = str(json_result[x[4]][x[1]]["selling_amount"])
		$DealerVyber/Dealer1/Name.bbcode_text = ("[center]"+json_result[x[4]][x[1]]["name"])
		$DealerVyber/Dealer1/Dealer1.icon = load("res://assets/"+x[4]+x[1]+".png")
		$DealerVyber/Dealer1/DealerID.text = x[1]
		match (json_result[x[4]][x[1]]["drugs"][1]):
			"weed": 
				print("weed")
				$DealerVyber/Dealer1/Drug2.texture = load("res://assets/weed.png") 
			"meth": 
				print("meth") 
				$DealerVyber/Dealer1/Drug2.texture = load("res://assets/pico.png") 
			"heroin": 
				print("heroin") 
				$DealerVyber/Dealer1/Drug2.texture = load("res://assets/herion.png") 
		match (json_result[x[4]][x[2]]["drugs"][0]):
				"weed": 
					print("weed")
					$DealerVyber/Dealer2/Drug1.texture = load("res://assets/weed.png") 
				"meth": 
					print("meth") 
					$DealerVyber/Dealer2/Drug1.texture = load("res://assets/pico.png") 
				"heroin": 
					print("heroin") 
					$DealerVyber/Dealer2/Drug1.texture = load("res://assets/herion.png") 
		$DealerVyber/Dealer2/ProfitCut.text = str(json_result[x[4]][x[2]]["profit_cut"])
		$DealerVyber/Dealer2/PoliceChance.text = str(json_result[x[4]][x[2]]["police_chance"])
		$DealerVyber/Dealer2/SellingAmount.text = str(json_result[x[4]][x[2]]["selling_amount"])
		$DealerVyber/Dealer2/Name.bbcode_text = ("[center]"+json_result[x[4]][x[2]]["name"])
		$DealerVyber/Dealer2/Dealer1.icon = load("res://assets/"+x[4]+x[2]+".png")
		$DealerVyber/Dealer2/DealerID.text = x[2]
		match (json_result[x[4]][x[2]]["drugs"][1]):
			"weed": 
				print("weed")
				$DealerVyber/Dealer2/Drug2.texture = load("res://assets/weed.png") 
			"meth": 
				print("meth") 
				$DealerVyber/Dealer2/Drug2.texture = load("res://assets/pico.png") 
			"heroin": 
				print("heroin") 
				$DealerVyber/Dealer2/Drug2.texture = load("res://assets/herion.png") 
		match (json_result[x[4]][x[3]]["drugs"][0]):
				"weed": 
					print("weed")
					$DealerVyber/Dealer3/Drug1.texture = load("res://assets/weed.png") 
				"meth": 
					print("meth") 
					$DealerVyber/Dealer3/Drug1.texture = load("res://assets/pico.png") 
				"heroin": 
					print("heroin") 
					$DealerVyber/Dealer3/Drug1.texture = load("res://assets/herion.png") 
		$DealerVyber/Dealer3/ProfitCut.text = str(json_result[x[4]][x[3]]["profit_cut"])
		$DealerVyber/Dealer3/PoliceChance.text = str(json_result[x[4]][x[3]]["police_chance"])
		$DealerVyber/Dealer3/SellingAmount.text = str(json_result[x[4]][x[3]]["selling_amount"])
		$DealerVyber/Dealer3/Name.bbcode_text = ("[center]"+json_result[x[4]][x[3]]["name"])
		$DealerVyber/Dealer3/Dealer1.icon = load("res://assets/"+x[4]+x[3]+".png")
		$DealerVyber/Dealer3/DealerID.text = x[3]
		match (json_result[x[4]][x[3]]["drugs"][1]):
			"weed": 
				print("weed")
				$DealerVyber/Dealer3/Drug2.texture = load("res://assets/weed.png") 
			"meth": 
				print("meth") 
				$DealerVyber/Dealer3/Drug2.texture = load("res://assets/pico.png") 
			"heroin": 
				print("heroin") 
				$DealerVyber/Dealer3/Drug2.texture = load("res://assets/herion.png") 
	if(x[0] == "loaddealers"):
		if int(x[2]) <= 0:
			$HoodPannel/Dealer1/ButtonCollect.visible = true
			collect[0] = true
			$HoodPannel/Dealer1/RichTextLabel.visible = false
			$HoodPannel/Dealer1/ProgressBar.visible = false#
		if int(x[2]) > 0:
			$HoodPannel/Dealer1/RichTextLabel.visible = true
			$HoodPannel/Dealer1/ProgressBar.visible = true
			$HoodPannel/Dealer1/Drug1.disabled = true
			$HoodPannel/Dealer1/Drug2.disabled = true
			#$HoodPannel/Dealer1/Dealer1.disabled = true
		if int(x[1]) == 0:
			$HoodPannel/Dealer1/ButtonCollect.visible = false
			$HoodPannel/Dealer1/Drug1.disabled = false
			$HoodPannel/Dealer1/Drug2.disabled = false
			#$HoodPannel/Dealer1/Dealer1.disabled = false
		if int(x[5]) <= 0:
			$HoodPannel/Dealer2/ButtonCollect.visible = true
			collect[1] = true
			$HoodPannel/Dealer2/RichTextLabel.visible = false
			$HoodPannel/Dealer2/ProgressBar.visible = false
		if int(x[5]) > 0:
			$HoodPannel/Dealer2/RichTextLabel.visible = true
			$HoodPannel/Dealer2/ProgressBar.visible = true
			$HoodPannel/Dealer2/Drug1.disabled = true
			$HoodPannel/Dealer2/Drug2.disabled = true
			#$HoodPannel/Dealer2/Dealer2.disabled = true
		if int(x[4]) == 0:
			$HoodPannel/Dealer2/ButtonCollect.visible = false
			$HoodPannel/Dealer2/Drug1.disabled = false
			$HoodPannel/Dealer2/Drug2.disabled = false
			#$HoodPannel/Dealer2/Dealer2.disabled = false
		var min1 = 0
		var sec1 = int(x[2])
		while sec1 > 59:
			min1+=1
			sec1-=60
		time[0]=min1
		time[1]=sec1
		var min2 = 0
		var sec2 = int(x[5])
		while sec2 > 59:
			min2+=1
			sec2-=60
		time[2]=min2
		time[3]=sec2
		if (sec1 > 9):
			$HoodPannel/Dealer1/RichTextLabel.text = "Zbývá: " +str(min1) + ":" + str(sec1)
		else:
			$HoodPannel/Dealer1/RichTextLabel.text = "Zbývá: " +str(min1) + ":0" + str(sec1)
		if (sec2 > 9):
			$HoodPannel/Dealer2/RichTextLabel.text = "Zbývá: " +str(min2) + ":" + str(sec2)
		else:
			$HoodPannel/Dealer2/RichTextLabel.text = "Zbývá: " +str(min2) + ":0" + str(sec2)
		$HoodPannel/Dealer1/ProgressBar/Label.text = x[3]+"/"+x[1]
		$HoodPannel/Dealer2/ProgressBar/Label.text = x[6]+"/"+x[4]
		$HoodPannel/Dealer1/ProgressBar.max_value = int(x[1])
		$HoodPannel/Dealer1/ProgressBar.value = int(x[3])
		$HoodPannel/Dealer2/ProgressBar.max_value = int(x[4])
		$HoodPannel/Dealer2/ProgressBar.value = int(x[6])

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)

func _on_ButtonInv_pressed():
	$Inv.visible = true

func _on_ButtonInvExit_pressed():
	$Inv.visible = false

func _on_ButtonExit_pressed():
	$ExitPanel.visible = true

func _on_ExitButtonYes_pressed():
	get_tree().quit()

func _on_ExitButtonNo_pressed():
	$ExitPanel.visible = false

func _on_ButtonHoodExit_pressed():
	$HoodPannel/Dealer1Remain1.visible = false
	$HoodPannel/Dealer1Remain2.visible = false
	$HoodPannel/Dealer2Remain1.visible = false
	$HoodPannel/Dealer2Remain2.visible = false
	$HoodPannel.visible = false
	$HoodPannel/Timer.stop()
	$HoodPannel/Timer2.stop()

func hood_click(var bbtext,var id):
	var text = loadd()
	$HoodPannel.visible = true
	$HoodPannel/HoodName.bbcode_text = bbtext
	$HoodPannel/HoodiD.text = str(id)
	_send("hood" + text + "$" + str(id))
	_send("loaddealers"+text+"$" + str(id))
	$HoodPannel/Timer.start()
	$HoodPannel/Timer2.start()

func _on_borovina_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			hood_click("[center]Borovina[/center]",1)
			

func _on_horkasever_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 2:
				hood_click("[center]Horka domky sever[/center]",2)

func _on_horkajih_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 3:
				hood_click("[center]Horka domky jih[/center]",3)

func _on_stopshop_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 4:
				hood_click("[center]Stop shop[/center]",4)

func _on_prumyslova_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 5:
				hood_click("[center]Průmyslová čtvrť[/center]",5)

func _on_nemocnice_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 6:
				hood_click("[center]Nemocnice[/center]",6)

func _on_namesti_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 7:
				hood_click("[center]Centrum[/center]",7)

func _on_zid_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 8:
				hood_click("[center]Židovská čtvrť[/center]",8)


func _on_podklasteri_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 9:
				hood_click("[center]Podkláštěří[/center]",9)
				

func _on_kokain_ctvrt_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 10:
				hood_click("[center]Čtvrť zbohatlíků[/center]",10)

func _on_tyn_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 11:
				hood_click("[center]Týn[/center]",11)

func _on_atom_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 12:
				hood_click("[center]Hotel atom[/center]",12)

func _on_spst_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 13:
				hood_click("[center]SPŠT[/center]",13)



func _on_pole_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().change_scene("res://pole.tscn")

func mouse_enter(var hood,var id,var full_txt):
	get_node("Trebic/"+hood+"/Line2D").points = get_node("Trebic/"+hood+"/CollisionPolygon2D").polygon
	get_node("Trebic/"+hood+"/Line2D").show()
	get_node("Trebic/"+hood+"/RichTextLabel").show()
	if int(unlockedHoods) >= int(id):
		get_node("Trebic/"+hood+"/Line2D").default_color = Color.green
		get_node("Trebic/"+hood+"/RichTextLabel").add_color_override("default_color",Color.green)
		get_node("Trebic/"+hood+"/RichTextLabel").text = full_txt
	else:
		get_node("Trebic/"+hood+"/Line2D").default_color = Color.red
		get_node("Trebic/"+hood+"/RichTextLabel").add_color_override("default_color",Color.red)

func _on_horkasever_mouse_entered():
	mouse_enter("horkaSever",2, "Horka domky sever")

func _on_horkasever_mouse_exited():
	$Trebic/horkaSever/Line2D.hide()
	$Trebic/horkaSever/RichTextLabel.hide()

func _on_horkajih_mouse_entered():
	mouse_enter("horkaJih",3, "Horka domky jih")

func _on_horkajih_mouse_exited():
	$Trebic/horkaJih/Line2D.hide()
	$Trebic/horkaJih/RichTextLabel.hide()

func _on_stopshop_mouse_entered():
	mouse_enter("StopShop",4, "Stop Shop")

func _on_stopshop_mouse_exited():
	$Trebic/StopShop/Line2D.hide()
	$Trebic/StopShop/RichTextLabel.hide()

func _on_prumyslova_mouse_entered():
	mouse_enter("prumyslova",5, "Průmyslová čtvrť")

func _on_prumyslova_mouse_exited():
	$Trebic/prumyslova/Line2D.hide()
	$Trebic/prumyslova/RichTextLabel.hide()

func _on_nemocnice_mouse_entered():
	mouse_enter("nemocnice",6, "Nemocnice")

func _on_nemocnice_mouse_exited():
	$Trebic/nemocnice/Line2D.hide()
	$Trebic/nemocnice/RichTextLabel.hide()

func _on_namesti_mouse_entered():
	mouse_enter("namesti",7, "Centrum")

func _on_namesti_mouse_exited():
	$Trebic/namesti/Line2D.hide()
	$Trebic/namesti/RichTextLabel.hide()

func _on_zid_mouse_entered():
	mouse_enter("zid",8, "Židovská čtvrť")

func _on_zid_mouse_exited():
	$Trebic/zid/Line2D.hide()
	$Trebic/zid/RichTextLabel.hide()

func _on_podklasteri_mouse_entered():
	mouse_enter("podklasteri",9, "Podkláštěří")

func _on_podklasteri_mouse_exited():
	$Trebic/podklasteri/Line2D.hide()
	$Trebic/podklasteri/RichTextLabel.hide()

func _on_kokain_ctvrt_mouse_entered():
	mouse_enter("kokain_ctvrt",10, "Čtvrť zbohatlíků")

func _on_kokain_ctvrt_mouse_exited():
	$Trebic/kokain_ctvrt/Line2D.hide()
	$Trebic/kokain_ctvrt/RichTextLabel.hide()

func _on_tyn_mouse_entered():
	mouse_enter("tyn",11, "Týn")

func _on_tyn_mouse_exited():
	$Trebic/tyn/Line2D.hide()
	$Trebic/tyn/RichTextLabel.hide()

func _on_atom_mouse_entered():
	mouse_enter("atom",12, "Atom")

func _on_atom_mouse_exited():
	$Trebic/atom/Line2D.hide()
	$Trebic/atom/RichTextLabel.hide()

func _on_spst_mouse_entered():
	mouse_enter("spst",13, "SPŠT")

func _on_spst_mouse_exited():
	$Trebic/spst/Line2D.hide()
	$Trebic/spst/RichTextLabel.hide()

func _on_pole_mouse_entered():
	$Trebic/pole/Line2D.points = $Trebic/pole/CollisionPolygon2D.polygon
	$Trebic/pole/Line2D.show()
	$Trebic/pole/RichTextLabel.show()
	$Trebic/pole/Line2D.default_color = Color.green
	$Trebic/pole/RichTextLabel.add_color_override("default_color",Color.green)
	$Trebic/pole/RichTextLabel.text = "Pole"

func _on_pole_mouse_exited():
	$Trebic/pole/Line2D.hide()
	$Trebic/pole/RichTextLabel.hide()

func _on_Dealer1_pressed():
	if $HoodPannel/Dealer1/Dealer1.icon != load("res://assets/none.png"): 
		
		return
	$HoodPannel.visible = false
	$DealerVyber.visible = true
	var text = loadd()
	_send("showdealers"+ text + "$" +$HoodPannel/HoodiD.text)

func _on_Dealer2_pressed():
	if $HoodPannel/Dealer2/Dealer2.icon != load("res://assets/none.png"): 
		
		return
	$HoodPannel.visible = false
	$DealerVyber.visible = true
	var text = loadd()
	_send("showdealers"+ text + "$" +$HoodPannel/HoodiD.text)

func _on_ButtonVyberExit_pressed():
	$DealerVyber.visible = false

func _on_ButtonDealer1_pressed():
	
	_send("assigndealer" + text +"$" + $HoodPannel/HoodiD.text + "$" +$DealerVyber/Dealer1/DealerID.text)
	$DealerVyber.visible = false

func _on_ButtonDealer2_pressed():
	
	_send("assigndealer" + text +"$" + $HoodPannel/HoodiD.text + "$" +$DealerVyber/Dealer2/DealerID.text)
	$DealerVyber.visible = false

func _on_ButtonDealer3_pressed():
	
	_send("assigndealer" + text +"$" + $HoodPannel/HoodiD.text + "$" +$DealerVyber/Dealer3/DealerID.text)
	$DealerVyber.visible = false

func _on_1Drug1_pressed():
	$HoodPannel/Dealer1Remain1.visible = true
	$HoodPannel/Dealer1Remain2.visible = false
	$HoodPannel/Dealer1Remain1/HSlider.max_value = int($HoodPannel/Dealer1/SellingAmount.text)
	$HoodPannel/Dealer1Remain1/Icon.icon = $HoodPannel/Dealer1/Drug1.icon

func _on_1Drug2_pressed():
	$HoodPannel/Dealer1Remain1.visible = false
	$HoodPannel/Dealer1Remain2.visible = true
	$HoodPannel/Dealer1Remain2/HSlider.max_value = int($HoodPannel/Dealer1/SellingAmount.text)
	$HoodPannel/Dealer1Remain2/Icon.icon = $HoodPannel/Dealer1/Drug2.icon

func _on_2Drug1_pressed():
	$HoodPannel/Dealer2Remain1.visible = true
	$HoodPannel/Dealer2Remain2.visible = false
	$HoodPannel/Dealer2Remain1/HSlider.max_value = int($HoodPannel/Dealer2/SellingAmount.text)
	$HoodPannel/Dealer2Remain1/Icon.icon = $HoodPannel/Dealer2/Drug1.icon

func _on_2Drug2_pressed():
	$HoodPannel/Dealer2Remain1.visible = false
	$HoodPannel/Dealer2Remain2.visible = true
	$HoodPannel/Dealer2Remain2/HSlider.max_value = int($HoodPannel/Dealer2/SellingAmount.text)
	$HoodPannel/Dealer2Remain2/Icon.icon = $HoodPannel/Dealer2/Drug2.icon

func _on_1HSlider1_value_changed(value):
	$HoodPannel/Dealer1Remain1/ButtonSend.text = "Prodat " + str($HoodPannel/Dealer1Remain1/HSlider.value) 

func _on_1HSlider2_value_changed(value):
	$HoodPannel/Dealer1Remain2/ButtonSend.text = "Prodat " + str($HoodPannel/Dealer1Remain2/HSlider.value)

func _on_1ButtonSend1_pressed():
	_send("sendtodealer"+text+ "$" +$HoodPannel/HoodiD.text + "$1$" + $HoodPannel/Dealer1/Drug1.text + "$" + str($HoodPannel/Dealer1Remain1/HSlider.value)  )
	collect[0] = false
	TimeStampID = 12
	$HoodPannel/Dealer1Remain1.visible = false
	_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
	_send("hood" + text + "$" + $HoodPannel/HoodiD.text)
	$HoodPannel/Dealer1/RichTextLabel.visible = true
	$HoodPannel/Dealer1/ProgressBar.visible = true

func _on_1ButtonSend2_pressed():
	_send("sendtodealer"+text+ "$" +$HoodPannel/HoodiD.text + "$1$" + $HoodPannel/Dealer1/Drug2.text + "$" + str($HoodPannel/Dealer1Remain2/HSlider.value)  )
	collect[0] = false
	TimeStampID = 12
	$HoodPannel/Dealer1Remain2.visible = false
	_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
	_send("hood" + text + "$" + $HoodPannel/HoodiD.text)
	$HoodPannel/Dealer1/RichTextLabel.visible = true
	$HoodPannel/Dealer1/ProgressBar.visible = true

func _on_2HSlider1_value_changed(value):
	$HoodPannel/Dealer2Remain1/ButtonSend.text = "Prodat " + str($HoodPannel/Dealer2Remain1/HSlider.value) 

func _on_2HSlider2_value_changed(value):
	$HoodPannel/Dealer2Remain2/ButtonSend.text = "Prodat " + str($HoodPannel/Dealer2Remain2/HSlider.value) 

func _on_2ButtonSend1_pressed():
	_send("sendtodealer"+text+ "$" +$HoodPannel/HoodiD.text + "$2$" + $HoodPannel/Dealer2/Drug1.text + "$" + str($HoodPannel/Dealer2Remain1/HSlider.value)  )
	collect[1] = false
	TimeStampID = 21
	$HoodPannel/Dealer2Remain1.visible = false
	_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
	_send("hood" + text + "$" + $HoodPannel/HoodiD.text)
	$HoodPannel/Dealer2/RichTextLabel.visible = true
	$HoodPannel/Dealer2/ProgressBar.visible = true

func _on_2ButtonSend2_pressed():
	_send("sendtodealer"+text+ "$" +$HoodPannel/HoodiD.text + "$2$" + $HoodPannel/Dealer2/Drug2.text + "$" + str($HoodPannel/Dealer2Remain2/HSlider.value)  )
	collect[1] = false
	TimeStampID = 22
	$HoodPannel/Dealer2Remain2.visible = false
	_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
	_send("hood" + text + "$" + $HoodPannel/HoodiD.text)
	$HoodPannel/Dealer2/RichTextLabel.visible = true
	$HoodPannel/Dealer2/ProgressBar.visible = true

func _on_ButtonCollect1_pressed():
	_send("takeprofit"+text+"$"+$HoodPannel/HoodiD.text+ "$1")
	$HoodPannel/Dealer1/ButtonCollect.visible = false
	_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
	_send("loadmap" + text)
	$HoodPannel/Dealer1/RichTextLabel.visible = false

func _on_ButtonCollect2_pressed():
	_send("takeprofit"+text+"$"+$HoodPannel/HoodiD.text+ "$2")
	$HoodPannel/Dealer2/ButtonCollect.visible = false
	_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
	_send("loadmap" + text)
	$HoodPannel/Dealer2/RichTextLabel.visible = false
	$HoodPannel/Dealer2/ProgressBar.visible = false

func _on_Timer_timeout():
	time[1]-=1
	time[3]-=1
	if(time[2] + time[3] < 0 && !collect[1]):
		_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
		collect[1] = true
	else:
		if (time[3]<0):
			time[2]-=1
			time[3]=59
		if (time[3] > 9):
			$HoodPannel/Dealer2/RichTextLabel.text = "Zbývá: " + str(time[2]) + ":" + str(time[3])
		else:
			$HoodPannel/Dealer2/RichTextLabel.text = "Zbývá: " +str(time[2]) + ":0" + str(time[3])
		
	if(time[0] + time[1] < 0 && !collect[0]):
		_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
		collect[0] = true
	else:
		if (time[1]<0):
			time[0]-=1
			time[1]=59
		if (time[1] > 9):
			$HoodPannel/Dealer1/RichTextLabel.text = "Zbývá: " +str(time[0]) + ":" + str(time[1])
		else:
			$HoodPannel/Dealer1/RichTextLabel.text = "Zbývá: " +str(time[0]) + ":0" + str(time[1])

func _on_Varna1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().change_scene("res://varna_scene1.tscn")

func _on_Varna2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) < 3:
				OS.alert("Tuto varnu nemáš odemknutou!")
				return
			get_tree().change_scene("res://varna_scene2.tscn")

func _on_Varna3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) < 5:
				OS.alert("Tuto varnu nemáš odemknutou!")
				return
			get_tree().change_scene("res://varna_scene3.tscn")

func _on_Varna4_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) < 7:
				OS.alert("Tuto varnu nemáš odemknutou!")
				return
			get_tree().change_scene("res://varna_scene4.tscn")

func _on_Varna5_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) < 9:
				OS.alert("Tuto varnu nemáš odemknutou!")
				return
			get_tree().change_scene("res://varna_scene5.tscn")

func _on_Varna6_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) < 11:
				OS.alert("Tuto varnu nemáš odemknutou!")
				return
			get_tree().change_scene("res://varna_scene6.tscn")

func _on_Varna7_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) < 13:
				OS.alert("Tuto varnu nemáš odemknutou!")
				return
			get_tree().change_scene("res://varna_scene7.tscn")


func _on_Timer2_timeout():
	_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
