extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton:
		#if event.button_index == BUTTON_LEFT and event.pressed:
			#print("atom")
			#OS.alert("test")
			#$Panel.visible = true



func _on_Button_pressed():
	$Panel.visible = false
