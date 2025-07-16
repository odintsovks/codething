extends Area2D

const eventname = "DropArea"

func updateShape():#Putting it into _ready won't work because the modded image doesn't update in time for it
	var shape=get_child(0).shape
	if shape.get_class() == "RectangleShape2D":
		var texture=get_parent().get_texture()
		shape.set_extents(Vector2(texture.get_width(),texture.get_height())/2)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		var nodebase=get_parent().get_parent()
		if event.button_index == MOUSE_BUTTON_LEFT:
			if generalUtils.eventReceiver==eventname and nodebase.get_child_count()==1 and event.is_pressed() and not event.is_alt_pressed():
				var newobj=generalUtils.get_mouse().get_child(1).duplicate()
				nodebase.add_child(newobj)
				newobj.set_inputs_readonly(false)
			elif nodebase.get_child_count()>1 and event.is_alt_pressed():
				if event.is_pressed():
					gameSceneUtils.set_event_owner(self)
				elif gameSceneUtils.is_event_owner(self):
					for i in nodebase.get_child(1).inputs:
						var safeWireArray=i.connectedWires.duplicate()
						for w in safeWireArray:
							w.cleanup_and_queue_free()
					for o in nodebase.get_child(1).outputs:
						var safeWireArray=o.connectedWires.duplicate()
						for w in safeWireArray:
							w.cleanup_and_queue_free()
					nodebase.get_child(1).queue_free()
