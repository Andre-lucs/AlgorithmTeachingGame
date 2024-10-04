@tool
class_name OutPutConnection extends Area2D

signal number_requested
signal numbers_received(numbers: Array[Number])

func _init() -> void:
  set_collision_layer_value(1,false)
  set_collision_mask_value(1,false)
  set_collision_layer_value(5, true)

func request_numbers() :
  number_requested.emit()

func send_numbers(numbers: Array[Number]) :
  numbers_received.emit(numbers)
