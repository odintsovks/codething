extends ColorRect

@onready var mouseobj = generalUtils.get_mouse()

func _on_RubbishPanel_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index()==MOUSE_BUTTON_LEFT and event.is_pressed():
			if mouseobj.get_child_count() != 1:
				mouseobj.get_child(1).queue_free()
				generalUtils.eventReceiver=""
			elif mouseobj.get_parent().get_child_count() != 1:
				generalUtils.get_mouse().hasWire=false
				mouseobj.get_parent().get_child(1).queue_free()
				generalUtils.eventReceiver=""


func _on_RubbishPanel_resized():
	get_child(0).set_position(size*Vector2(0.5,0.5))
