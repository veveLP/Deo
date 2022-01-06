extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Line2D.points = $CollisionPolygon2D.polygon
	$Line2D.hide()
	$Line2D.default_color = Color.green
	$RichTextLabel.hide()
	


func _on_borovina_mouse_entered():
	$Line2D.show()
	$RichTextLabel.show()


func _on_borovina_mouse_exited():
	$Line2D.hide()
	$RichTextLabel.hide()



