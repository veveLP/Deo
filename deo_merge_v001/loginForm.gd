extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func loadd():
	var file = File.new()
	file.open("res://save_game.dat", File.READ)
	var content = file.get_line()
	file.close()
	return content
# Called when the node enters the scene tree for the first time.
func _ready():
	var loaded = loadd()
	print (loaded)
	var x = loaded.split("$")
	print (x[1])
	
	$Panel/LineEdit.text = x[1]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func save(content):
	var file = File.new()
	file.open("res://save_game.dat", File.WRITE)
	file.store_string(content)
	file.close()

var check = false

func _on_Button_pressed():
	
	print($Panel/LineEdit.text)
	print($Panel/LineEdit2.text)
	var password = $Panel/LineEdit2.text
	print(password.sha256_text())
	password = password.sha256_text()
	password = password.left(10)
	save("$"+$Panel/LineEdit.text+"$"+password)
	get_tree().change_scene("res://Trebic.tscn")
	if (check):
		OS.window_fullscreen = true
	else:
		OS.window_size = Vector2(1920,1080)


func _on_CheckBox_toggled(button_pressed):
	if (check):
		check = false
	else:
		check = true
