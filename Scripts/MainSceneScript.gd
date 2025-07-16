extends Node2D

const initHeight=600
var IDResolveQueue={}
var resolvedIDList={}

func _ready():
	var _err = get_tree().get_root().connect("size_changed", Callable(self, "onresize"))
	if generalUtils.loadSave:
		generalUtils.loadSave=false
		generalUtils.get_game_scene().get_camera_3d().set_position(generalUtils.savedCameraPos)
		var zoom = Vector2(generalUtils.savedCameraZoom,generalUtils.savedCameraZoom)
		generalUtils.get_game_scene().zoom=zoom
		generalUtils.get_game_scene().get_camera_3d().set_zoom(zoom)
		load_game()

func save_game():
	var codeNodeArray = generalUtils.get_game_scene().find_child("CodeNodeArray")
	codeNodeArray.save_game()
func load_game():
	if not FileAccess.file_exists("user://savegame.json"):
		errorHandler.warn("No save to load!")
		return
	var saveGame = FileAccess.open("user://savegame.json", FileAccess.READ)
	var codeNodeArray = generalUtils.get_game_scene().find_child("CodeNodeArray")
	while saveGame.get_position() < saveGame.get_length():
		var test_json_conv = JSON.new()
		test_json_conv.parse(saveGame.get_line())
		var saveData = test_json_conv.get_data()
		for i in saveData:
			codeNodeArray.get_child(i[0][0]+i[0][1]*4).add_child(load(i[1]).instantiate())
			codeNodeArray.get_child(i[0][0]+i[0][1]*4).get_child(1).load_game(i[2])
	for i in IDResolveQueue.keys():
		resolvedIDList[i].connectedTo.push_back(IDResolveQueue[i])
		for j in IDResolveQueue[i]:
			j.connectedTo.push_back(resolvedIDList[i])
			var wire = find_child("Wires").add_wire()
			wire.recreate(j,resolvedIDList[i])
			j.add_wire(wire)
			resolvedIDList[i].add_wire(wire)
	IDResolveQueue.clear()
	resolvedIDList.clear()
	saveGame.close()#almost made a memory leak lmao

func onresize():
	var size = get_viewport_rect().size
	get_child(0).set_size(size)#Screen
	#get_child(0).get_child(0).get_child(0).set_size(size)#GameViewport
	#get_child(0).get_child(2).get_child(0).set_size(size)#UIViewport
	#var UIContainerNode=get_node("/root/Scene/Screen/UIContainer")
	#UIContainerNode.set_size(size)
	#UIContainerNode.get_child(0).set_size(size)
	#UIContainerNode.get_child(0).get_child(0).set_size(size)
	#var newscale=size.y/initHeight
	#UIContainerNode.get_child(0).get_child(0).set_scale(Vector2(newscale,newscale))
	#var gameContainerNode=get_node("/root/Scene/GameContainer")
	#gameContainerNode.set_size(Vector2(size.x-size.y*0.25,size.y))
	#gameContainerNode.get_child(0).set_size(Vector2(size.x-size.y*0.25,size.y))
	#gameContainerNode.set_position(Vector2(size.y*0.25-1,0))
