extends TextureButton
func _pressed():
	match get_tree().change_scene_to_file("res://Scenes/MainScene.tscn"):
		ERR_CANT_OPEN:
			errorHandler.error("Opening code scene failed!")
		ERR_CANT_CREATE:
			errorHandler.error("Code scene failed to get instantiated!")
#Basic scene switch from main menu to the code game
