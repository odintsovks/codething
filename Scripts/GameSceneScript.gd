extends Node2D

const minzoom=0.001

var scrollSensitivity = 0.2
var mouseSensitivity = -1
var mousePosOld
var moveCameraToMouse=false
var zooming=false
var activeFactor=0
var operations=[]
var timeElapsed=0
var tickSlider = 0

@onready var viewport = get_viewport()
@onready var camera = get_camera_3d()
@onready var zoom = Vector2(1,1)


func get_camera_3d():
	return find_child("Camera2D")
func _input(event):
	if event.is_action_pressed("camera_pin"):
		mousePosOld=viewport.get_mouse_position()
		moveCameraToMouse=true
	elif event.is_action_released("camera_pin"):
		moveCameraToMouse=false
		camera.set_position(camera.get_position()+camera.get_offset())
		camera.set_offset(Vector2(0,0))
	if event.is_action_pressed("zoom_in") and not moveCameraToMouse:
		activeFactor-=event.get_factor()*scrollSensitivity
	elif event.is_action_pressed("zoom_out") and not moveCameraToMouse:
		activeFactor+=event.get_factor()*scrollSensitivity
	if event.is_action_pressed("deleter"):
		Input.set_custom_mouse_cursor(preload("res://Images/RubbishBinCursor.png"))
	elif event.is_action_released("deleter"):
		Input.set_custom_mouse_cursor(null)
	if event.is_action_pressed("saver"):
		generalUtils.get_node("/root/Scene").save_game()
	if event.is_action_pressed("loader"):
		generalUtils.loadSave=true
		generalUtils.savedCameraPos=camera.get_position()+camera.get_offset()
		generalUtils.savedCameraZoom=zoom.x
		var _err = get_tree().reload_current_scene()
func tick():
	for i in operations:
		if is_instance_valid(i[0]):
			i[0].updateVal(i[1])
			i[0].set_undefined(i[2])
	operations.clear()
	for i in find_child("CodeNodeArray").get_children():
		if i.get_child_count()>1:
			i.get_child(1).calculate()
	for i in get_node("/root/Scene/Screen/Wires").get_children():
		operations.push_back([i.endpoint,i.startpoint.val,i.startpoint.undefined])
func zoomCamera(factor: float):
	zoom-=Vector2(factor,factor)
	zoom.x=max(minzoom,zoom.x)
	zoom.y=max(minzoom,zoom.y)
	var oldpoint=get_global_mouse_position()
	camera.set_zoom(zoom)
	camera.set_position(camera.get_position()-get_global_mouse_position()+oldpoint)
	activeFactor-=factor
func _process(delta):
	if tickSlider!=0:
		timeElapsed+=delta
		#print("deltaTime "+String(delta))
		#print("timeElapsed "+String(timeElapsed))
		var mathes=1.0/tickSlider
		while timeElapsed>=mathes:
			timeElapsed-=mathes
			tick()
	if activeFactor!=0:
		zooming=true
		zoomCamera(activeFactor)
	else:
		zooming=false
	if moveCameraToMouse:
		camera.set_offset((viewport.get_mouse_position()-mousePosOld)*mouseSensitivity/zoom)#multiply by zoom so that the sens doesn't scale with zoom
func set_tick_slider(value: int):
	tickSlider=value
	timeElapsed=0
