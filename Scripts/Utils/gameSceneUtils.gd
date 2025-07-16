extends Node

var eventOwner=-1

func set_event_owner(event_owner:Node):
	eventOwner=event_owner.get_instance_id()
	#print(eventOwner)
func is_event_owner(event_owner:Node):
	return event_owner.get_instance_id()==eventOwner
