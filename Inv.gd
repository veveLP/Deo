extends Panel


export var SOCKET_URL = "ws://194.15.112.30:6988"

var client = WebSocketClient.new()


# Called when the node enters the scene tree for the first time.
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
	_send("inventory" + text)

func _on_ButtonExit_pressed():
	pass # Replace with function body.


func _on_data():
	var payload = client.get_peer(1).get_packet().get_string_from_utf8()
	print("Received data: ", payload)
	var x = payload.split("$")
	if (x[0] == "inventory"):
		$RichTextLabel.bbcode_text = "[center]" + x[1] + "[/center]"
		$RichTextLabel2.bbcode_text = "[center]" + x[2] + "[/center]"
		$RichTextLabel3.bbcode_text = "[center]" + x[3] + "[/center]"
		$SeminkoText.text = x[4]
		$HnujText.text = "level: " + x[5]
		$VarnaText.text = x[6]
		$AcetonText.text = x[7]
		$HydroxidText.text = x[8]
		$KyselinaText.text = x[9]
		$EtherText.text = x[10]
		$EfedrinText.text = x[11]
		$VaricText.text = x[12]
		$ChloroformText.text = x[13]
		$UhlicitanText.text = x[14]
		$AlkoholText.text = x[16]
		$OcetText.text = x[17]
		$CpavekText.text = x[18]
		$VapnoText.text = x[19]
		
		
	
	
	
func _send(text):
	var packet: PoolByteArray = text.to_utf8()
	print("Sending: " + text)
	client.get_peer(1).put_packet(packet)

