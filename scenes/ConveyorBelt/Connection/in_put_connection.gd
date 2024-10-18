@tool
class_name InputConnection extends Area2D

signal numbers_received(numbers: Array[Number])


func _init() -> void:
  set_collision_layer_value(1,false)
  set_collision_mask_value(1,false)
  set_collision_layer_value(4, true)

func receive_numbers(numbers: Array[Number]):
  numbers_received.emit(numbers)
