@tool
extends Node2D
class_name Number

@onready var number_text : Label = $Label
@onready var find_input_area: Area2D = $FindInputArea

@export var value : int :
	set(v):
		value = v
		if number_text:
			number_text.text = str(v)
		else: $Label.text = str(v)


func _on_find_input_area_area_entered(area: Area2D) -> void:
	if typeof(area) == typeof(InputConnection) and find_input_area.monitoring:
		find_input_area.queue_free()
		var conn := area as InputConnection;
		conn.receive_numbers([self])
