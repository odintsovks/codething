extends Node2D
#CodeNodeArray size values
@export var width = 4
@export var height = 4
@export var margin = 10

func _ready():
	var CodeNodeArrayBlockScene = preload("res://Prefabs/CodeNodeArrayBlock.tscn") #CodeNodeArrayBlock prefab
	var sizeTestInstance=CodeNodeArrayBlockScene.instantiate()
	var modSprite = generalUtils.findByClass(sizeTestInstance.get_children(),"Sprite2D")
	var posDiff = Vector2(modSprite.imgWidth+margin/get_scale()[0],modSprite.imgHeight+margin/get_scale()[1])
	sizeTestInstance.queue_free()
	for y in height:
		for x in width:
			var block=CodeNodeArrayBlockScene.instantiate()
			add_child(block)
			block.set_position(Vector2(x,y)*posDiff)
func save_game():
	var saveData=[]
	for y in height:
		for x in width:
			if get_child(x+y*4).get_child_count()>1:
				var child=get_child(x+y*4).get_child(1)
				saveData.append([[x,y],child.filename,child.save_game()])
	var saveGame = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	saveGame.store_line(JSON.stringify(saveData))
	saveGame.close()
#func load_game() moved to MainSceneScript
