extends Node2D

@onready var scene=generalUtils.get_game_scene()
@onready var camera=scene.find_child("Camera2D")
const vectorOne=Vector2(1,1)

func _process(_delta):
	pass
	#set_position((-camera.get_position()-camera.get_offset())/scene.zoom)
	#set_scale(vectorOne/scene.zoom)
func add_wire():
	var wireprefab=preload("res://Prefabs/WirePrefab.tscn")
	var wireinst=wireprefab.instantiate()
	add_child(wireinst)
	return wireinst
