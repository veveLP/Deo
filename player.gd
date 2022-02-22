extends KinematicBody2D

var scene
var moving = false
var dir = "up"

func _ready():
	scene = str(get_tree().get_current_scene().get_name())

export (int) var speed = 200

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		moving = true
		dir = "right"
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		moving = true
		dir = "left"
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		moving = true
		dir = "down"
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		moving = true
		dir = "up"
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	if (moving):
		$AnimatedSprite.play(dir)
	else:
		$AnimatedSprite.play("standing_" + dir)
	velocity = move_and_slide(velocity)
	moving = false
