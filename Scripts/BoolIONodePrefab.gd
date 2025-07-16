extends Node2D

var val=false
#export var maxInputChar=3

var readonly=false
@export var input=false
@export var standalone=false
var undefined=false
var connectedTo=[]
var connectedWires=[]

#onready var textedit=get_child(0).get_child(0).get_child(0)

const eventname="IO"

func set_undefined(newval:bool):
	undefined=newval
	get_child(1).get_child(2).set_visible(newval)
	if newval:
		get_child(1).get_child(0).set_visible(false)
		get_child(1).get_child(1).set_visible(false)
	else:
		updateVal(val)
func add_wire(wire:Node2D):
	connectedWires.push_back(wire)
	if input:
		set_undefined(true)
		if not standalone:
			get_parent().calculate()
		set_readonly(true)
func _ready():
	updateVal(val)
	if (input):
		set_input()
	else:
		set_output()
func set_input():
	get_child(0).set_modulate(generalUtils.CLRINPUT)
	get_child(1).get_child(0).set_modulate(generalUtils.CLRINPUT)
	get_child(1).get_child(1).set_modulate(generalUtils.CLRINPUT)
	get_child(1).get_child(2).set_modulate(generalUtils.CLRINPUT)
	input=true
func set_output():
	get_child(0).set_modulate(generalUtils.CLROUTPUT)
	get_child(1).get_child(0).set_modulate(generalUtils.CLROUTPUT)
	get_child(1).get_child(1).set_modulate(generalUtils.CLROUTPUT)
	get_child(1).get_child(2).set_modulate(generalUtils.CLROUTPUT)
	#textedit.set_editable(false)
	set_readonly(true)
func set_readonly(rdval: bool):
	#textedit.set_editable(not rdval)
	#textedit.selecting_enabled=not rdval
	readonly=rdval
func _on_Area2D_input_event(_viewport, event, _shape_idx):
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
	val=bool(newval)
	get_child(1).get_child(0).set_visible(not val)
	get_child(1).get_child(1).set_visible(val)
	get_child(1).get_child(2).set_visible(undefined)


func _on_CheckMarkArea_input_event(_viewport, event, _shape_idx):
	if (readonly and standalone) or (not readonly and not standalone):
		if event is InputEventMouseButton:
			if event.get_button_index()==MOUSE_BUTTON_LEFT and not event.is_pressed():
				updateVal(not val)
