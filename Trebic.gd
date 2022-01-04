extends Node2D

export var SOCKET_URL = "ws://194.15.112.30:6988"
var client = WebSocketClient.new()
# Called when the node enters the scene tree for the first time.
var unlockedHoods = 1

#func getHoods() :
#	return unlockedHoods

func _ready():
	
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
	
func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	var x = payload.split("$")
	if (x[0] == "loadmap"):
		$RichTextLabelMoney.text = x[2]
		unlockedHoods = x[1] 
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
			
			
		
		$RichTextLabel2.bbcode_text = "[center]Respekt: " + str(stepify(test,0.1)) +text+ "[/center]"
		

func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_Button_pressed():
	$HoodPannel.visible = false



func _on_ButtonExit_pressed():
	get_tree().quit()


func _on_borovina_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			$HoodPannel.visible = true
			$HoodPannel/RichTextLabel5.bbcode_text = "[center]Borovina[/center]"
			


func _on_kokain_ctvrt_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 10:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Čtvrť zbohatlíků[/center]"


func _on_podklasteri_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 9:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Podkláštěří[/center]"


func _on_zid_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 8:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Židovská čtvrť[/center]"


func _on_namesti_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 7:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Centrum[/center]"


func _on_spst_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 13:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]SPŠT[/center]"


func _on_tyn_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 11:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Týn[/center]"


func _on_atom_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 12:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Hotel atom[/center]"


func _on_horkasever_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 2:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Horka domky sever[/center]"


func _on_horkajih_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 3:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Horka domky jih[/center]"


func _on_stopshop_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 4:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Stop shop[/center]"


func _on_prumyslova_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 5:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Průmyslová čtvrť[/center]"


func _on_nemocnice_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if int(unlockedHoods) >= 6:
				$HoodPannel.visible = true
				$HoodPannel/RichTextLabel5.bbcode_text = "[center]Nemocnice[/center]"


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
