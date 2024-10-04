class_name MainConveyor extends Node2D

const NUMBER = preload("res://scenes/Number/Number.tscn")
@onready var numbers_origin: Marker2D = $NumbersOrigin
@onready var out_put_connection: OutPutConnection = $OutPutConnection

var numbers :Array[int] = []:
	set(value):
		numbers = value
		for n in numbers:
			var number = NUMBER.instantiate()
			number.value = n
			number_nodes.append(number)
			numbers_origin.add_child(number)
			number.find_input_area.queue_free()
		_position_numbers()
var number_nodes : Array[Number] = []

func _position_numbers():
	var pos := Vector2(0,0)
	for i in number_nodes:
		create_tween().tween_property(i, "position", pos, 0.4).set_trans(Tween.TRANS_LINEAR)
		pos.x -= 12*5

func _on_out_put_connection_number_requested() -> void:
	if number_nodes.size():
		out_put_connection.send_numbers([number_nodes.pop_front()])
		_position_numbers()
