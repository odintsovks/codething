extends Node2D

@onready var node = get_child(1)
var mouseOverRect=false
var mouseOverPanel=false

func createNode(prefab: PackedScene):
	var obj = prefab.instantiate()
	var spr = generalUtils.findByClass(obj.get_children(),"Sprite2D")
	var prefabscale = 1024.0/max(spr.imgWidth,spr.imgHeight)
	obj.set_scale(Vector2(prefabscale,prefabscale))
	node.add_child(obj)
	obj.set_inputs_readonly(true)
	node.move_child(obj,0)

func _on_ColorRect_mouse_entered():
	mouseOverRect=true

func _on_ColorRect_mouse_exited():
	mouseOverRect=false

func _on_Panel_mouse_entered():
	mouseOverPanel=true
func _on_Panel_mouse_exited():
	mouseOverPanel=false

func set_title(newTitle: String):
	get_child(2).set_text(newTitle)

func _input(event):
	if mouseOverRect or mouseOverPanel:
		if event is InputEventMouseButton:
			if event.is_action_pressed("preview_node_take") and generalUtils.eventReceiver=="":
				generalUtils.get_mouse().add_child(node.get_child(0).duplicate())
				generalUtils.eventReceiver="DropArea"
