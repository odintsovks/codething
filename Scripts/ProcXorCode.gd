extends Processor

func _ready():
	set_inputs([get_child(1),get_child(2)])
	set_outputs([get_child(3)])
func calculate():
	if not check_for_undefined(inputs,outputs):
		outputs[0].updateVal(inputs[0].val != inputs[1].val)
