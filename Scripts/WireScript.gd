extends Line2D

const height=9

#var updsecondpos=false
var mouseOver=false
var startpoint
var endpoint

func set_first_point(io:Node2D):
	var camera=generalUtils.get_game_scene().get_camera_3d()
	startpoint=io
	set_position(io.global_position-camera.get_position()-camera.get_offset())
	modulate.a8=127
	#updsecondpos=true
	generalUtils.get_mouse().hasWire=true

func recreate(start:Node2D,end:Node2D):
	startpoint=start
	endpoint=end
	set_position(start.global_position)
	var pos=end.global_position-get_position()
	set_point_position(1,pos)
	get_child(0).get_child(0).set_disabled(false)
	var offy=Vector2(height/2.0*cos(pos.angle()-PI/2),height/2.0*sin(pos.angle()-PI/2))
	var offx=Vector2(height/2.0*cos(pos.angle()),height/2.0*sin(pos.angle()))
	get_child(0).get_child(0).set_polygon(PackedVector2Array([offy-offx,pos+offy+offx,pos+offx-offy,-offx-offy]))

#Code moved to MouseObjectScript for efficiency
#func _process(_delta):
#	if updsecondpos:
#		set_scale(Vector2(1,1)/scene.zoom)
#		var mathes=startpoint.global_position-camera.get_position()-camera.get_offset()
#		set_position(mathes/scene.zoom+container.rect_position)
#		set_point_position(1,(get_global_mouse_position()-container.rect_position)*scene.zoom-mathes)

func cleanup_and_queue_free():
	if is_instance_valid(startpoint):
		startpoint.connectedTo.erase(endpoint)
		startpoint.connectedWires.erase(self)
	if is_instance_valid(endpoint):
		endpoint.connectedTo.erase(startpoint)
		endpoint.connectedWires.erase(self)
		endpoint.set_undefined(false)
		endpoint.set_readonly(false)
	queue_free()

func _unhandled_input(event):
	if mouseOver:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_alt_pressed():
				get_viewport().set_input_as_handled()
				if event.is_pressed():
					gameSceneUtils.set_event_owner(self)
				elif gameSceneUtils.is_event_owner(self):
					cleanup_and_queue_free()

#func _on_Area2D_area_entered(area):
#	if area.name=="MouseArea":
#		mouseOver=true
#		modulate.a8=127


#func _on_Area2D_area_exited(area):
#	if area.name=="MouseArea":
#		mouseOver=false
#		modulate.a8=255


func _on_area_2d_mouse_entered() -> void:
	mouseOver=true
	modulate.a8=127


func _on_area_2d_mouse_exited() -> void:
	mouseOver=false
	modulate.a8=255
