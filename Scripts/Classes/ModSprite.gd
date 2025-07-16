extends Sprite2D

class_name ModSprite

var imgWidth=1024
var imgHeight=1024

func _ready():
	var imgName = modLoader.splitFilenameByFormat(texture.resource_path.split("/")[-1])[0]
	if imgName in modLoader.modImageExtensionList:
		var image=modLoader.loadImage(imgName)
		imgWidth=image.get_width()
		imgHeight=image.get_height()
		set_texture(ImageTexture.create_from_image(image))
		generalUtils.findByClass(get_children(),"Area2D").updateShape()
