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
	


func _on_Button_button_down():
	if timer < 4:
		$MethMinigameMake/Timer.start()
	

func _on_Button_button_up():
	$MethMinigameMake/Timer.stop()
	if timer < 4:
		pole[timer] = count
		count = 0
		#$Label.text = str($ProgressBar.value)
		timer += 1
		if timer == 4:
			print(str(pole[0]) +","+ str(pole[1]) +","+ str(pole[2]) +","+ str(pole[3]))
			for i in 4:
				error += abs(25-pole[i])
			if(error <= 3):
				print("0")
			elif(error <= 6):
				print("1")
			elif(error <= 10):
				print("2")
			elif(error <= 15):
				print("3")
			elif(error <= 20):
				print("4")
			else:
				print("5")


func _on_Timer_timeout():
	if($MethMinigameMake/ProgressBar.value > 99):
		$MethMinigameMake/Timer.stop()
	$MethMinigameMake/ProgressBar.value += 1
	count+= 1
