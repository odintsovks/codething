extends Sprite2D

var mouseOver=false

func _on_Area2D_mouse_entered():
	mouseOver=true

func _on_Area2D_mouse_exited():
	mouseOver=false

func _input(event):
	if mouseOver and event is InputEventMouseButton and event.is_pressed():
		print("input")
