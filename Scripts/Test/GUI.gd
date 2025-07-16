extends Sprite2D

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		get_child(0).accept_event()
