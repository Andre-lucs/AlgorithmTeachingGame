extends CharacterBody2D
class_name NumberContainer

@onready var input_connection: InputConnection = $InputConnection
@onready var out_put_connection: OutPutConnection = $OutPutConnection
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
const NUMBER = preload("res://scenes/Number/Number.tscn")

const next_number_position := Vector2(40,40)
const gap_size := 2
const border_size := 6
const item_width := 10

@export var numbers : Array[Number] = [] :
	set(value):
		numbers = value
		for i in numbers:
			add_child(i)

var numbers_width: float = border_size:
	set(value):
		numbers_width = value
		create_tween().tween_property(nine_patch_rect, "custom_minimum_size:x", value, 0.2).set_trans(Tween.TRANS_ELASTIC)

func _process(_delta:float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		add_number(NUMBER.instantiate())
	if Input.is_action_just_pressed("ui_cancel"):
		if numbers.size() > 0:
			remove_number(numbers[-1], true)

func add_number(number: Number):
	numbers.append(number)
	if number.get_parent():
		number.reparent(self)
	else: add_child(number)
	var pos := next_number_position + Vector2((numbers_width-border_size)*5, 0)
	create_tween().tween_property(number, "position", pos, 0.2).set_trans(Tween.TRANS_BOUNCE)
	numbers_width += item_width+gap_size

func remove_number(number: Number, free: bool = false):
	numbers.erase(number)
	numbers_width -= item_width+gap_size
	if free: number.queue_free()
	var pos = Vector2(40,40)
	for i in numbers:
		create_tween().tween_property(i, "position", pos, 0.1)
		pos += Vector2((item_width+gap_size)*5, 0)

func _clear(free := false):
	for i in numbers:
		remove_number(i, free)
	numbers_width = border_size

func _send_numbers() -> void:
	if numbers.size() == 0: return;
	var number : Array[Number] = [numbers.front()]
	remove_number(number.front())
	out_put_connection.send_numbers(number);

func _on_input_connection_numbers_received(new_numbers: Array[Number]) -> void:
	print("recieved:",new_numbers)
	for i in new_numbers:
		i.global_rotation_degrees = 0
		call_deferred("add_number", i);
		#add_number(i);
