@tool
class_name OutPutConnection extends Area2D

signal number_requested
signal numbers_received(numbers: Array[Number])

var connected_conveyors : Array[ConveyorBelt] = []

func _init() -> void:
	set_collision_layer_value(1,false)
	set_collision_mask_value(1,false)
	set_collision_layer_value(5, true)

func request_numbers() :
	number_requested.emit()

func send_numbers(numbers: Array[Number]) :
	numbers_received.emit(numbers)

func connect_conveyor(new_conveyor : ConveyorBelt, on_numbers_recieved : Callable):
	connected_conveyors.append(new_conveyor)
	numbers_received.connect(on_numbers_recieved)

func activate_conveyors():
	for i in connected_conveyors:
		i.activate()
