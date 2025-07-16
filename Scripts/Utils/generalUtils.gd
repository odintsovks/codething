extends Node

const CLRINPUT = Color.LIGHT_BLUE
const CLROUTPUT = Color.PALE_VIOLET_RED
var eventReceiver = ""
var loadSave=false
var savedCameraZoom=1
var savedCameraPos=Vector2(0,0)

func set_eventReceiver(val: String):
	eventReceiver=val
func get_mouse():
	return get_node("/root/Scene/MouseLayer/MouseObject")
func get_UI_scene():
	return get_node("/root/Scene/Screen/UIContainer/UIViewport/UIScene")
func get_game_scene():
	return get_node("/root/Scene/Screen/GameScene")
func findByClass(arr : Array, cls: String):
	for i in arr:
		if i.get_class() == cls:
			return i
