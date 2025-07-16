extends Node2D

var hasWire=false

@onready var scene=generalUtils.get_game_scene()
@onready var camera=scene.find_child("Camera2D")

func _process(_delta):
	set_position(get_global_mouse_position())
	set_scale(Vector2(0.05,0.05)*scene.zoom)
	if hasWire:
		var wire = get_parent().get_child(1)
		wire.set_scale(Vector2(1,1)*scene.zoom)
		var mathes=(wire.startpoint.global_position-camera.get_position()-camera.get_offset())*scene.zoom
		wire.set_position(mathes)
		wire.set_point_position(1,(get_global_mouse_position()-mathes)/scene.zoom)

func _input(event):
	if hasWire or get_child_count()>1:
		if event is InputEventMouseButton:
			if event.button_index==MOUSE_BUTTON_LEFT and event.is_alt_pressed():
				get_viewport().set_input_as_handled()
				if event.is_pressed():
					gameSceneUtils.set_event_owner(self)
				elif gameSceneUtils.is_event_owner(self):
					if hasWire:
						generalUtils.get_mouse().hasWire=false
						get_parent().get_child(1).queue_free()
						generalUtils.eventReceiver=""
					elif get_child_count()>1:
						get_child(1).queue_free()
						generalUtils.eventReceiver=""
