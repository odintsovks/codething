extends ColorRect

const previewsize = 1536
const uiwidth = 140
const margin=10
const procPath="res://Prefabs/Processors/"

var activeFactor=0
var lowestpoint=-1.0

func _ready():
	var previewscale = (uiwidth-20.0)/previewsize
	var preview = preload("res://Prefabs/NodePreviewPrefab.tscn")
	var dir = DirAccess.open(procPath)
	var _err = dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name = dir.get_next()
	var index=0
	var mathes=uiwidth/2.0
	while file_name != "":
		if not dir.current_is_dir():
			var obj = preview.instantiate()
			get_child(0).add_child(obj)
			obj.createNode(load(procPath+file_name))
			obj.set_scale(Vector2(previewscale,previewscale))
			obj.set_position(Vector2(mathes,mathes+index*(previewsize*previewscale+margin)))
			obj.set_title(modLoader.splitFilenameByFormat(file_name)[0])
			index+=1
			file_name = dir.get_next()
	lowestpoint=get_child(0).get_child(get_child(0).get_child_count()-1).get_position().y+mathes
	_on_PreviewPanel_resized()

func _process(_delta):
	get_child(1).set_value(get_child(1).value+activeFactor*5)
	activeFactor=0

func _on_PreviewPanel_resized():
	var mathes=get_size().x/uiwidth
	get_child(0).set_scale(Vector2(mathes,mathes))
	var oldratio=get_child(1).value/get_child(1).min_value
	mathes=get_size().y-lowestpoint*mathes
	get_child(1).min_value=mathes
	get_child(1).value=oldratio*mathes
	_on_VScrollBar_value_changed(get_child(1).value)

func _on_PreviewPanel_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.get_button_index()==MOUSE_BUTTON_WHEEL_UP:
			activeFactor-=event.get_factor()
		elif event.get_button_index()==MOUSE_BUTTON_WHEEL_DOWN:
			activeFactor+=event.get_factor()


func _on_VScrollBar_gui_input(event):
	_on_PreviewPanel_gui_input(event)


func _on_VScrollBar_value_changed(value):
	get_child(0).position.y=get_child(1).min_value-value
