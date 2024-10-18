@tool
class_name Connections extends Node2D

func activate_out_connections():
	var out_con = get_children().filter(func(i): return i is OutPutConnection)
	
	for i in out_con:
		if i is OutPutConnection: i.activate_conveyors()

func _get_configuration_warnings() -> PackedStringArray:
	if !get_children().any(func(i): return i is OutPutConnection or i is InputConnection):
		return ["The connections node needs a InputCOnnection or an OutPutConnection as children"]
	return []

static func has_connections(node : Node2D) -> Connections:
	var connection : Connections = node.get_children().filter(func(i): return i is Connections).front()
	return connection
