extends Control

var held=false
var mouseOver=false
var oldMouseX=0

func _on_HorizontalResizer_gui_input(event):
	if event is InputEventMouseButton and event.get_button_index()==MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			oldMouseX=get_global_mouse_position().x-offset_right
			held=true
		else:
			held=false

func _process(_delta):
	if held:
		offset_right=max(150,get_global_mouse_position().x-oldMouseX)
