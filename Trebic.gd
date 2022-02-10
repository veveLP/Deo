extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"
var client = WebSocketClient.new()
# Called when the node enters the scene tree for the first time.
var unlockedHoods = 1

#func getHoods() :
#	return unlockedHoods

var text = loadd()
var time = [null,null,null,null]
var collect = [false, false]

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

func _process(delta):
	client.poll()

func _on_connection_closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)
	
func loadd():
	var file = File.new()
	file.open("res://save_game.dat", File.READ)
	var content = file.get_line()
	file.close()
	return content
	
func _on_connected(proto = ""):
	var text = loadd()
	print("Connected with protocol: ", proto)
	_send("loadmap" + text)
	###############################################################
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
		$HoodPannel/Dealer1/Dealer1.disabled = true
		
		
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
					pass
				"meth": 
					print("meth") 
					$HoodPannel/Dealer1/Drug1.icon = load("res://assets/pico.png") 
					$HoodPannel/Dealer1/Drug1.text = "meth"
					pass
				"heroin": 
					print("heroin") 
					$HoodPannel/Dealer1/Drug1.icon = load("res://assets/herion.png") 
					$HoodPannel/Dealer1/Drug1.text = "heroin"
					pass
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
					pass
				"meth": 
					print("meth") 
					$HoodPannel/Dealer1/Drug2.icon = load("res://assets/pico.png") 
					$HoodPannel/Dealer1/Drug2.text = "meth"
					pass
				"heroin": 
					print("heroin") 
					$HoodPannel/Dealer1/Drug2.icon = load("res://assets/herion.png") 
					$HoodPannel/Dealer1/Drug2.text = "heroin"
					pass
					
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
					pass
				"meth": 
					print("meth") 
					$HoodPannel/Dealer2/Drug1.icon = load("res://assets/pico.png") 
					$HoodPannel/Dealer2/Drug1.text = "meth"
					pass
				"heroin": 
					print("heroin") 
					$HoodPannel/Dealer2/Drug1.icon = load("res://assets/herion.png")
					$HoodPannel/Dealer2/Drug1.text = "heroin" 
					pass
		
			match (json_result[x[9]][x[8]]["drugs"][1]):
				"weed": 
					print("weed")
					$HoodPannel/Dealer2/Drug2.icon = load("res://assets/weed.png") 
					$HoodPannel/Dealer2/Drug2.text = "weed"
					pass
				"meth": 
					print("meth") 
					$HoodPannel/Dealer2/Drug2.icon = load("res://assets/pico.png") 
					$HoodPannel/Dealer2/Drug2.text = "meth"
					pass
				"heroin": 
					print("heroin") 
					$HoodPannel/Dealer2/Drug2.icon = load("res://assets/herion.png") 
					$HoodPannel/Dealer2/Drug2.text = "heroin"
					pass
		
		
		##########################################################################################
		
		
		#print("hood received")
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
					pass
				"meth": 
					print("meth") 
					$DealerVyber/Dealer1/Drug1.texture = load("res://assets/pico.png") 
					pass
				"heroin": 
					print("heroin") 
					$DealerVyber/Dealer1/Drug1.texture = load("res://assets/herion.png") 
					pass
					
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
				pass
			"meth": 
				print("meth") 
				$DealerVyber/Dealer1/Drug2.texture = load("res://assets/pico.png") 
				pass
			"heroin": 
				print("heroin") 
				$DealerVyber/Dealer1/Drug2.texture = load("res://assets/herion.png") 
				pass
					
		#################################################################
		
		match (json_result[x[4]][x[2]]["drugs"][0]):
				"weed": 
					print("weed")
					$DealerVyber/Dealer2/Drug1.texture = load("res://assets/weed.png") 
					pass
				"meth": 
					print("meth") 
					$DealerVyber/Dealer2/Drug1.texture = load("res://assets/pico.png") 
					pass
				"heroin": 
					print("heroin") 
					$DealerVyber/Dealer2/Drug1.texture = load("res://assets/herion.png") 
					pass
					
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
				pass
			"meth": 
				print("meth") 
				$DealerVyber/Dealer2/Drug2.texture = load("res://assets/pico.png") 
				pass
			"heroin": 
				print("heroin") 
				$DealerVyber/Dealer2/Drug2.texture = load("res://assets/herion.png") 
				pass
		#######################################################################
		
		
		
		match (json_result[x[4]][x[3]]["drugs"][0]):
				"weed": 
					print("weed")
					$DealerVyber/Dealer3/Drug1.texture = load("res://assets/weed.png") 
					pass
				"meth": 
					print("meth") 
					$DealerVyber/Dealer3/Drug1.texture = load("res://assets/pico.png") 
					pass
				"heroin": 
					print("heroin") 
					$DealerVyber/Dealer3/Drug1.texture = load("res://assets/herion.png") 
					pass
					
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
				pass
			"meth": 
				print("meth") 
				$DealerVyber/Dealer3/Drug2.texture = load("res://assets/pico.png") 
				pass
			"heroin": 
				print("heroin") 
				$DealerVyber/Dealer3/Drug2.texture = load("res://assets/herion.png") 
				pass
	
	if(x[0] == "loaddealers"):
		if int(x[2]) <= 0:
			$HoodPannel/Dealer1/ButtonCollect.visible = true
			collect[0] = true
			$HoodPannel/Dealer1/RichTextLabel.visible = false
		if int(x[2]) > 0:
			$HoodPannel/Dealer1/RichTextLabel.visible = true
			$HoodPannel/Dealer1/Drug1.disabled = true
			$HoodPannel/Dealer1/Drug2.disabled = true
			$HoodPannel/Dealer1/Dealer1.disabled = true
		if int(x[1]) == 0:
			$HoodPannel/Dealer1/ButtonCollect.visible = false
			$HoodPannel/Dealer1/Drug1.disabled = false
			$HoodPannel/Dealer1/Drug2.disabled = false
			$HoodPannel/Dealer1/Dealer1.disabled = false
		if int(x[5]) <= 0:
			$HoodPannel/Dealer2/ButtonCollect.visible = true
			collect[1] = true
			$HoodPannel/Dealer2/RichTextLabel.visible = false
		if int(x[5]) > 0:
			$HoodPannel/Dealer2/RichTextLabel.visible = true
			$HoodPannel/Dealer2/Drug1.disabled = true
			$HoodPannel/Dealer2/Drug2.disabled = true
			$HoodPannel/Dealer2/Dealer2.disabled = true
		if int(x[4]) == 0:
			$HoodPannel/Dealer2/ButtonCollect.visible = false
			$HoodPannel/Dealer2/Drug1.disabled = false
			$HoodPannel/Dealer2/Drug2.disabled = false
			$HoodPannel/Dealer2/Dealer2.disabled = false
			
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


###############################################################################


func _on_Button_pressed():
	$HoodPannel.visible = false
	$HoodPannel/Timer.stop()



func _on_ButtonExit_pressed():
	$ExitPanel.visible = true


func _on_borovina_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var text = loadd()
			$HoodPannel.visible = true
			$HoodPannel/HoodName.bbcode_text = "[center]Borovina[/center]"
			$HoodPannel/HoodiD.text = "1"
			_send("hood" + text + "$1")
			_send("loaddealers"+text+"$1")
			$HoodPannel/Timer.start()

func _on_kokain_ctvrt_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 10:
				
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Čtvrť zbohatlíků[/center]"
				$HoodPannel/HoodiD.text = "10"
				_send("hood" + text + "$10")
				_send("loaddealers"+text+"$10")
				$HoodPannel/Timer.start()


func _on_podklasteri_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 9:
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Podkláštěří[/center]"
				$HoodPannel/HoodiD.text = "9"
				_send("hood" + text + "$9")
				_send("loaddealers"+text+"$9")
				$HoodPannel/Timer.start()


func _on_zid_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 8:
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Židovská čtvrť[/center]"
				$HoodPannel/HoodiD.text = "8"
				_send("hood" + text + "$8")
				_send("loaddealers"+text+"$8")
				$HoodPannel/Timer.start()


func _on_namesti_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 7:
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Centrum[/center]"
				$HoodPannel/HoodiD.text = "7"
				_send("hood" + text + "$7")
				_send("loaddealers"+text+"$7")
				$HoodPannel/Timer.start()


func _on_spst_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 13:
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]SPŠT[/center]"
				$HoodPannel/HoodiD.text = "13"
				_send("hood" + text + "$13")
				_send("loaddealers"+text+"$13")
				$HoodPannel/Timer.start()


func _on_tyn_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 11:
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Týn[/center]"
				$HoodPannel/HoodiD.text = "11"
				_send("hood" + text + "$11")
				_send("loaddealers"+text+"$11")
				$HoodPannel/Timer.start()


func _on_atom_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 12:
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Hotel atom[/center]"
				$HoodPannel/HoodiD.text = "12"
				_send("hood" + text + "$12")
				_send("loaddealers"+text+"$12")
				$HoodPannel/Timer.start()


func _on_horkasever_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 2:
				var text = loadd()
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Horka domky sever[/center]"
				$HoodPannel/HoodiD.text = "2"
				_send("hood" + text + "$2")
				_send("loaddealers"+text+"$2")
				$HoodPannel/Timer.start()


func _on_horkajih_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 3:
				var text = loadd()
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Horka domky jih[/center]"
				$HoodPannel/HoodiD.text = "3"
				_send("hood" + text + "$3")
				_send("loaddealers"+text+"$3")
				$HoodPannel/Timer.start()


func _on_stopshop_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 4:
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Stop shop[/center]"
				$HoodPannel/HoodiD.text = "4"
				_send("hood" + text + "$4")
				_send("loaddealers"+text+"$4")
				$HoodPannel/Timer.start()


func _on_prumyslova_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 5:
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Průmyslová čtvrť[/center]"
				$HoodPannel/HoodiD.text = "5"
				_send("hood" + text + "$5")
				_send("loaddealers"+text+"$5")
				$HoodPannel/Timer.start()


func _on_nemocnice_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 6:
				$HoodPannel.visible = true
				$HoodPannel/HoodName.bbcode_text = "[center]Nemocnice[/center]"
				$HoodPannel/HoodiD.text = "6"
				_send("hood" + text + "$6")
				_send("loaddealers"+text+"$6")
				$HoodPannel/Timer.start()
				

func _on_pole_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().change_scene("res://pole.tscn")



##############################################################

func _on_ButtonInv_pressed():
	$Inv.visible = true


func _on_ButtonInvExit_pressed():
	$Inv.visible = false

##############################################################




func _on_horkasever_mouse_entered():
	$Trebic/horkaSever/Line2D.points = $Trebic/horkaSever/CollisionPolygon2D.polygon
	$Trebic/horkaSever/Line2D.show()
	$Trebic/horkaSever/RichTextLabel.show()
	if int(unlockedHoods) >= 2:
		$Trebic/horkaSever/Line2D.default_color = Color.green
		$Trebic/horkaSever/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/horkaSever/RichTextLabel.text = "Horka domky sever"
	else:
		$Trebic/horkaSever/Line2D.default_color = Color.red
		$Trebic/horkaSever/RichTextLabel.add_color_override("default_color",Color.red)

func _on_horkasever_mouse_exited():
	$Trebic/horkaSever/Line2D.hide()
	$Trebic/horkaSever/RichTextLabel.hide()



func _on_horkajih_mouse_entered():
	$Trebic/horkaJih/Line2D.points = $Trebic/horkaJih/CollisionPolygon2D.polygon
	$Trebic/horkaJih/Line2D.show()
	$Trebic/horkaJih/RichTextLabel.show()
	if int(unlockedHoods) >= 3:
		$Trebic/horkaJih/Line2D.default_color = Color.green
		$Trebic/horkaJih/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/horkaJih/RichTextLabel.text = "Horka domky jih"
	else:
		$Trebic/horkaJih/Line2D.default_color = Color.red
		$Trebic/horkaJih/RichTextLabel.add_color_override("default_color",Color.red)

func _on_horkajih_mouse_exited():
	$Trebic/horkaJih/Line2D.hide()
	$Trebic/horkaJih/RichTextLabel.hide()



func _on_stopshop_mouse_entered():
	$Trebic/StopShop/Line2D.points = $Trebic/StopShop/CollisionPolygon2D.polygon
	$Trebic/StopShop/Line2D.show()
	$Trebic/StopShop/RichTextLabel.show()
	if int(unlockedHoods) >= 4:
		$Trebic/StopShop/Line2D.default_color = Color.green
		$Trebic/StopShop/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/StopShop/RichTextLabel.text = "Stop Shop"
	else:
		$Trebic/StopShop/Line2D.default_color = Color.red
		$Trebic/StopShop/RichTextLabel.add_color_override("default_color",Color.red)

func _on_stopshop_mouse_exited():
	$Trebic/StopShop/Line2D.hide()
	$Trebic/StopShop/RichTextLabel.hide()


func _on_prumyslova_mouse_entered():
	$Trebic/prumyslova/Line2D.points = $Trebic/prumyslova/CollisionPolygon2D.polygon
	$Trebic/prumyslova/Line2D.show()
	$Trebic/prumyslova/RichTextLabel.show()
	if int(unlockedHoods) >= 5:
		$Trebic/prumyslova/Line2D.default_color = Color.green
		$Trebic/prumyslova/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/prumyslova/RichTextLabel.text = "Průmyslová čtvrť"
	else:
		$Trebic/prumyslova/Line2D.default_color = Color.red
		$Trebic/prumyslova/RichTextLabel.add_color_override("default_color",Color.red)

func _on_prumyslova_mouse_exited():
	$Trebic/prumyslova/Line2D.hide()
	$Trebic/prumyslova/RichTextLabel.hide()


func _on_nemocnice_mouse_entered():
	$Trebic/nemocnice/Line2D.points = $Trebic/nemocnice/CollisionPolygon2D.polygon
	$Trebic/nemocnice/Line2D.show()
	$Trebic/nemocnice/RichTextLabel.show()
	if int(unlockedHoods) >= 6:
		$Trebic/nemocnice/Line2D.default_color = Color.green
		$Trebic/nemocnice/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/nemocnice/RichTextLabel.text = "Nemocnice"
	else:
		$Trebic/nemocnice/Line2D.default_color = Color.red
		$Trebic/nemocnice/RichTextLabel.add_color_override("default_color",Color.red)

func _on_nemocnice_mouse_exited():
	$Trebic/nemocnice/Line2D.hide()
	$Trebic/nemocnice/RichTextLabel.hide()



func _on_namesti_mouse_entered():
	$Trebic/namesti/Line2D.points = $Trebic/namesti/CollisionPolygon2D.polygon
	$Trebic/namesti/Line2D.show()
	$Trebic/namesti/RichTextLabel.show()
	if int(unlockedHoods) >= 7:
		$Trebic/namesti/Line2D.default_color = Color.green
		$Trebic/namesti/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/namesti/RichTextLabel.text = "Centrum"
	else:
		$Trebic/namesti/Line2D.default_color = Color.red
		$Trebic/namesti/RichTextLabel.add_color_override("default_color",Color.red)

func _on_namesti_mouse_exited():
	$Trebic/namesti/Line2D.hide()
	$Trebic/namesti/RichTextLabel.hide()



func _on_zid_mouse_entered():
	$Trebic/zid/Line2D.points = $Trebic/zid/CollisionPolygon2D.polygon
	$Trebic/zid/Line2D.show()
	$Trebic/zid/RichTextLabel.show()
	if int(unlockedHoods) >= 8:
		$Trebic/zid/Line2D.default_color = Color.green
		$Trebic/zid/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/zid/RichTextLabel.text = "Židovská čtvrť"
	else:
		$Trebic/zid/Line2D.default_color = Color.red
		$Trebic/zid/RichTextLabel.add_color_override("default_color",Color.red)

func _on_zid_mouse_exited():
	$Trebic/zid/Line2D.hide()
	$Trebic/zid/RichTextLabel.hide()



func _on_podklasteri_mouse_entered():
	$Trebic/podklasteri/Line2D.points = $Trebic/podklasteri/CollisionPolygon2D.polygon
	$Trebic/podklasteri/Line2D.show()
	$Trebic/podklasteri/RichTextLabel.show()
	if int(unlockedHoods) >= 9:
		$Trebic/podklasteri/Line2D.default_color = Color.green
		$Trebic/podklasteri/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/podklasteri/RichTextLabel.text = "Podkláštěří"
	else:
		$Trebic/podklasteri/Line2D.default_color = Color.red
		$Trebic/podklasteri/RichTextLabel.add_color_override("default_color",Color.red)

func _on_podklasteri_mouse_exited():
	$Trebic/podklasteri/Line2D.hide()
	$Trebic/podklasteri/RichTextLabel.hide()



func _on_kokain_ctvrt_mouse_entered():
	$Trebic/kokain_ctvrt/Line2D.points = $Trebic/kokain_ctvrt/CollisionPolygon2D.polygon
	$Trebic/kokain_ctvrt/Line2D.show()
	$Trebic/kokain_ctvrt/RichTextLabel.show()
	if int(unlockedHoods) >= 10:
		$Trebic/kokain_ctvrt/Line2D.default_color = Color.green
		$Trebic/kokain_ctvrt/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/kokain_ctvrt/RichTextLabel.text = "Čtvrť zbohatlíků"
	else:
		$Trebic/kokain_ctvrt/Line2D.default_color = Color.red
		$Trebic/kokain_ctvrt/RichTextLabel.add_color_override("default_color",Color.red)

func _on_kokain_ctvrt_mouse_exited():
	$Trebic/kokain_ctvrt/Line2D.hide()
	$Trebic/kokain_ctvrt/RichTextLabel.hide()



func _on_tyn_mouse_entered():
	$Trebic/tyn/Line2D.points = $Trebic/tyn/CollisionPolygon2D.polygon
	$Trebic/tyn/Line2D.show()
	$Trebic/tyn/RichTextLabel.show()
	if int(unlockedHoods) >= 11:
		$Trebic/tyn/Line2D.default_color = Color.green
		$Trebic/tyn/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/tyn/RichTextLabel.text = "Týn"
		
	else:
		$Trebic/tyn/Line2D.default_color = Color.red
		$Trebic/tyn/RichTextLabel.add_color_override("default_color",Color.red)

func _on_tyn_mouse_exited():
	$Trebic/tyn/Line2D.hide()
	$Trebic/tyn/RichTextLabel.hide()



func _on_atom_mouse_entered():
	$Trebic/atom/Line2D.points = $Trebic/atom/CollisionPolygon2D.polygon
	$Trebic/atom/Line2D.show()
	$Trebic/atom/RichTextLabel.show()
	if int(unlockedHoods) >= 12:
		$Trebic/atom/Line2D.default_color = Color.green
		$Trebic/atom/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/atom/RichTextLabel.text = "Atom"
	else:
		$Trebic/atom/Line2D.default_color = Color.red
		$Trebic/atom/RichTextLabel.add_color_override("default_color",Color.red)

func _on_atom_mouse_exited():
	$Trebic/atom/Line2D.hide()
	$Trebic/atom/RichTextLabel.hide()



func _on_spst_mouse_entered():
	$Trebic/spst/Line2D.points = $Trebic/spst/CollisionPolygon2D.polygon
	$Trebic/spst/Line2D.show()
	$Trebic/spst/RichTextLabel.show()
	if int(unlockedHoods) >= 13:
		$Trebic/spst/Line2D.default_color = Color.green
		$Trebic/spst/RichTextLabel.add_color_override("default_color",Color.green)
		$Trebic/spst/RichTextLabel.text = "SPŠT"
	else:
		$Trebic/spst/Line2D.default_color = Color.red
		$Trebic/spst/RichTextLabel.add_color_override("default_color",Color.red)

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

#####################################################################

func _on_ExitButtonYes_pressed():
	get_tree().quit()


func _on_ExitButtonNo_pressed():
	$ExitPanel.visible = false

#####################################################################


func _on_Dealer1_pressed():
	if $HoodPannel/Dealer1/Dealer1.icon != load("res://assets/none.png"): 
		OS.alert("debug")
		return
	$HoodPannel.visible = false
	$DealerVyber.visible = true
	var text = loadd()
	_send("showdealers"+ text + "$" +$HoodPannel/HoodiD.text)

func _on_Dealer2_pressed():
	if $HoodPannel/Dealer2/Dealer2.icon != load("res://assets/none.png"): 
		OS.alert("debug")
		return
	$HoodPannel.visible = false
	$DealerVyber.visible = true
	var text = loadd()
	_send("showdealers"+ text + "$" +$HoodPannel/HoodiD.text)




func _on_ButtonVyberExit_pressed():
	#$HoodPannel.visible = true
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
	
func _on_1ButtonSend2_pressed():
	_send("sendtodealer"+text+ "$" +$HoodPannel/HoodiD.text + "$1$" + $HoodPannel/Dealer1/Drug2.text + "$" + str($HoodPannel/Dealer1Remain2/HSlider.value)  )
	collect[0] = false
	TimeStampID = 12
	$HoodPannel/Dealer1Remain2.visible = false
	_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
	_send("hood" + text + "$" + $HoodPannel/HoodiD.text)
	$HoodPannel/Dealer1/RichTextLabel.visible = true
	
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
	
var TimeStampID
var TimeStamp

func _on_2ButtonSend2_pressed():
	_send("sendtodealer"+text+ "$" +$HoodPannel/HoodiD.text + "$2$" + $HoodPannel/Dealer2/Drug2.text + "$" + str($HoodPannel/Dealer2Remain2/HSlider.value)  )
	collect[1] = false
	TimeStampID = 22
	$HoodPannel/Dealer2Remain2.visible = false
	_send("loaddealers"+text+"$" + $HoodPannel/HoodiD.text)
	_send("hood" + text + "$" + $HoodPannel/HoodiD.text)
	$HoodPannel/Dealer2/RichTextLabel.visible = true

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
