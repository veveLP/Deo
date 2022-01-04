extends StaticBody2D

func _ready():
	$Line2D.points = $CollisionPolygon2D.polygon
	$Line2D.hide()

func _on_tyn_mouse_entered():
	$Line2D.show()

func _on_tyn_mouse_exited():
	$Line2D.hide()
