extends Node2D

class_name Processor

var inputs=[]
var outputs=[]

func set_inputs(inputArr: Array):
	inputs=inputArr
	for i in inputs:
		i.set_input()
func set_outputs(outputArr: Array):
	outputs=outputArr
	for o in outputs:
		o.set_output()
func save_game():
	var outArr={}
	var valueArr=[]
	var inputIDs=[]
	for i in inputs:
		valueArr.push_back(i.val*int(not i.readonly))
		inputIDs.push_back(i.get_instance_id())
	outArr["valueArr"]=valueArr
	outArr["inputIDs"]=inputIDs
	var outputIDs=[]
	var outputsConnectedTo=[]
	for o in outputs:
		outputIDs.push_back(o.get_instance_id())
		var reformattedArr=[]
		for i in o.connectedTo:
			reformattedArr.push_back(i.get_instance_id())
		outputsConnectedTo.push_back(reformattedArr)
	outArr["outputIDs"]=outputIDs
	outArr["outputsConnectedTo"]=outputsConnectedTo
	return outArr
func load_game(saveData: Dictionary):
	var mainScene=get_node("/root/Scene")
	for i in saveData["valueArr"].size():
		inputs[i].updateVal(saveData["valueArr"][i])
	for i in saveData["inputIDs"].size():
		mainScene.resolvedIDList[saveData["inputIDs"][i]]=inputs[i]
	for i in saveData["outputIDs"].size():
		mainScene.resolvedIDList[saveData["outputIDs"][i]]=outputs[i]
	for i in saveData["outputsConnectedTo"].size():
		for f in saveData["outputsConnectedTo"][i]:
			if mainScene.resolvedIDList.has(f):
				outputs[i].connectedTo.push_back(mainScene.resolvedIDList[f])
				mainScene.resolvedIDList[f].connectedTo.push_back(outputs[i])
				var wire = mainScene.find_child("Wires").add_wire()
				wire.recreate(outputs[i],mainScene.resolvedIDList[f])
				outputs[i].add_wire(wire)
				mainScene.resolvedIDList[f].add_wire(wire)
			else:
				if not mainScene.IDResolveQueue.has(f):
					mainScene.IDResolveQueue[f]=[]
				mainScene.IDResolveQueue[f].push_back(outputs[i])
func set_inputs_readonly(val: bool):
	for i in inputs:
		i.set_readonly(val)
func check_for_undefined(affected_inputs: Array, affected_outputs: Array):
	var test=false
	for i in affected_inputs:
		test=test or i.undefined
	for o in affected_outputs:
		o.set_undefined(test)
	return test
