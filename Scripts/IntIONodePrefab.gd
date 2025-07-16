extends Node2D

var val=0
@export var maxInputChar=3

var readonly=false
var input=false
var undefined=false
var connectedTo=[]
var connectedWires=[]

@onready var textedit=get_child(0).get_child(0).get_child(0)

const eventname="IO"

func set_undefined(newval:bool):
	undefined=newval
	if newval:
		textedit.set_text("")
	else:
		updateVal(val)
func add_wire(wire:Node2D):
	connectedWires.push_back(wire)
	if input:
		set_undefined(true)
		get_parent().calculate()
		set_readonly(true)
func _ready():
	updateVal(val)
func set_input():
	set_modulate(generalUtils.CLRINPUT)
	input=true
	textedit.set_max_length(maxInputChar)
func set_output():
	set_modulate(generalUtils.CLROUTPUT)
	textedit.set_editable(false)
func set_readonly(rdval: bool):
	textedit.set_editable(not rdval)
	textedit.selecting_enabled=not rdval
	readonly=rdval
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if not readonly:
		if event is InputEventMouseButton:
			if event.get_button_index()==MOUSE_BUTTON_LEFT and event.is_pressed() and not event.is_alt_pressed():
				if not input and generalUtils.eventReceiver=="":
					var wireprefab=preload("res://Prefabs/WirePrefab.tscn")
					var wireinst=wireprefab.instantiate()
					generalUtils.get_mouse().get_parent().add_child(wireinst)
					generalUtils.get_mouse().hasWire=true
					wireinst.set_first_point(self)
					generalUtils.eventReceiver=eventname
				elif input and generalUtils.eventReceiver==eventname:
					var oldwire=generalUtils.get_mouse().get_parent().get_child(1)
					if not oldwire.startpoint in connectedTo:
						var wireprefab=preload("res://Prefabs/WirePrefab.tscn")
						var wireinst=wireprefab.instantiate()
						wireinst.recreate(generalUtils.get_mouse().get_parent().get_child(1).startpoint,self)
						wireinst.startpoint.connectedTo.push_back(self)
						wireinst.startpoint.add_wire(wireinst)
						connectedTo.push_back(wireinst.startpoint)
						add_wire(wireinst)
						generalUtils.get_node("/root/Scene/Screen/Wires").add_child(wireinst)
						generalUtils.get_mouse().hasWire=false
						generalUtils.get_mouse().get_parent().get_child(1).queue_free()
						generalUtils.eventReceiver=""

func updateVal(newval):
	textedit.set_text(str(newval))
	_on_LineEdit_text_changed(newval)

func _on_LineEdit_text_changed(newval):
	val=newval
