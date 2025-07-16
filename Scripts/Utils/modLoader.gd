extends Node
var modImageExtensionList = {}
var modScriptExtensionList = {}
var modOtherFileList = []
var modlist = []
const modPath = "user://mods"
const imageFileFormats=["png","jpg","jpeg","bmp","exr","hdr","tga","webp","dds","svg","svgz"]
const scriptFileFormats=[]
const questionableImageFileFormats=["dds","svg","svgz"]
func loadImage(imgName : String):
	var img = Image.new()
	if img.load(modPath+"/"+imgName+"."+modImageExtensionList[imgName]) != OK:
		errorHandler.error("Loading mod image "+imgName+" failed!")
	return img
func splitFilenameByFormat(filename : String):#I separated it into a different function because it's convenient to access just this part from other scripts
	var splitFilename = filename.split(".")
	while splitFilename.size() > 2:#Just in case the filename contains dots
		splitFilename[0]=splitFilename[0]+"."+splitFilename[1]
		splitFilename.remove(1)#Not super efficient but i don't really care tbh
	splitFilename[1]=splitFilename[1].to_lower()#Linux is case-sensitive so we need it to always be lowercase
	return splitFilename
func fileTypeSorter(filename : String):
	var splitFilename = splitFilenameByFormat(filename)
	if splitFilename[1] in imageFileFormats:
		if splitFilename[1] in questionableImageFileFormats:
			errorHandler.warn("The image filetype ."+splitFilename[1]+" hasn't been tested and isn't supported yet. If you encounter any issues with the image contact the dev.")
		if splitFilename[0] in modImageExtensionList:
			errorHandler.warn("This image file was already added under a different format! Path3D: "+modImageExtensionList[splitFilename[0]])
		else:
			print("Adding to images list")
			modImageExtensionList[splitFilename[0]]=splitFilename[1]
	elif splitFilename[1] in scriptFileFormats:
		pass #To-do moddable script files
	else:
		modOtherFileList.push_back(filename)
func loadPaths():
	print("Searching for mod paths") 
	var dir = DirAccess.open(modPath)
	if dir != null:
		dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var filename = dir.get_next()
		while filename != "":
			if dir.current_is_dir():
				print("Found mod: " + filename + ", adding to the mod list")
				modlist.push_back(filename)
			else:
				print("Found file: " + filename + ", adding to the modded files list")
				fileTypeSorter(filename)
			filename = dir.get_next()
	else:
		errorHandler.error("mods folder not found!")
func _ready():
	loadPaths()
