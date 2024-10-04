class_name Deposit extends Node2D
@onready var marker_2d: Marker2D = $Marker2D

signal validate(number:Number)

func _on_input_connection_numbers_received(numbers: Array[Number]) -> void:
	for i in numbers:
		_recieve_numbers(i)
		validate.emit(i)

func _recieve_numbers(number: Number):
	if number.is_inside_tree():
		number.reparent(marker_2d)
	else:
		marker_2d.add_child(number)
	number.position.y = 0
	var t = create_tween()
	t.tween_property(number, "position", Vector2(350,0), 1)
