extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = 0
var count = 0
var pole = [0,0,0,0]
var error = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	#$Label.text = str($Timer.time_left)
	pass
	

func _on_leave_body_exited(body):
	get_tree().change_scene("res://Trebic.tscn")
	

var tablenumber = null
var tablecount = 32
var tableitems = []
var firsttime = "y"

func _get_tablenumber():
	var body = $player/body.get_overlapping_areas()
	tablenumber = null
	if (body.size()==0):
		pass
	else:
		var table = body[0]
		for i in tablecount+1:
			if(table.name == "slot" + String(i)):
				tablenumber = i
				OS.alert(str(tablenumber))
				print(str(tablenumber))
				break


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_E and firsttime == "y":
			firsttime = "n"
			_get_tablenumber()
			if tablenumber == null:
				pass
		else:
			firsttime = "y"



