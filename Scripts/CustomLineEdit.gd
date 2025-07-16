extends LineEdit

var mouseOver=false
var focused=false

func _input(event):
	#if focused and (generalUtils.eventReceiver!="" or (not mouseOver and (event is InputEventMouseButton and event.get_button_index()==BUTTON_LEFT and event.is_pressed()))):
	if (generalUtils.eventReceiver!="" or (not mouseOver and (event is InputEventMouseButton and event.get_button_index()==MOUSE_BUTTON_LEFT and event.is_pressed()))):
		if focused:
			release_focus()
		focused=false
		Input.set_default_cursor_shape(Input.CursorShape.CURSOR_ARROW)
func _unhandled_input(event):
	if generalUtils.eventReceiver=="" and (mouseOver or focused):
		var newevent=event.duplicate()
		#print(String(mouseOver)+","+String(focused))
		if newevent is InputEventMouseMotion or newevent is InputEventMouseButton:
			newevent.set_position(get_local_mouse_position())
			#newevent.set_global_position(get_global_mouse_position())
		if newevent is InputEventMouseButton and newevent.get_button_index()==MOUSE_BUTTON_LEFT and newevent.is_pressed():
			if not focused:
				#print("grabbed focus")
				grab_focus()
			focused=true
		_gui_input(newevent)

func _on_Area2D_mouse_entered():
	mouseOver=true
	#print("mouse entered")
	if generalUtils.eventReceiver=="":
		Input.set_default_cursor_shape(Input.CursorShape.CURSOR_IBEAM)

func _on_Area2D_mouse_exited():
	mouseOver=false
	#print("mouse exited")
	if not focused:
		Input.set_default_cursor_shape(Input.CursorShape.CURSOR_ARROW)
