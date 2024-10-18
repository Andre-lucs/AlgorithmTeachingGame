class_name ConveyorBelt extends Node2D

static var MIN_CLICK_DISTANCE = 30

signal deactivated

@onready var solution : Solution = get_tree().get_first_node_in_group("solution");
@onready var path_2d = $Path2D
@onready var line_2d = $Line2D
@onready var start_area_2d: Area2D = $StartArea2D
@onready var end_area_2d: Area2D = $Line2D/EndArea2D
@onready var activation_delay: Timer = $ActivationDelay

@export var input : OutPutConnection;
@export var output : InputConnection;
@export var automatic := true;
@export var single_item := false;

var items : Array[Number] = [];
var lastClickPos := Vector2.ZERO
var created := false
var creating := false
var waiting_delay : bool = false
var active := false

func _turn_animation(on:bool):
	var speed = 1 if on else 0
	(($Line2D as Line2D).material as ShaderMaterial).set_shader_parameter("speed", speed)

func _process(_delta):
	if not created:
		_create_process()
	elif active : #solution.is_playing:
		_execute()

# creation methods

func _create_process():
		if creating:
			_create_step()
			return
		if Input.is_action_just_pressed("click_left"):
			_create()

func _create():
	if not input:
		_find_input()
	# if it doesn't find an input, it will destroy itself
	if not input:
		queue_free()
		return
	# if it finds an input, it will start creating
	creating = true
	_add_point(to_local(input.global_position));

func _create_step():
	if Input.is_action_pressed("click_left") :
		var mousePos = get_local_mouse_position()
		if mousePos.distance_to(lastClickPos) > MIN_CLICK_DISTANCE:
			_add_point(mousePos);
			lastClickPos = mousePos
	elif Input.is_action_just_released("click_left"):
		_finish_creating()

func _finish_creating():
	created = true;
	if _find_output():
		input.connect_conveyor(self, _on_numbers_received)

func _find_input():
	# search for input in the start area
		var areas := start_area_2d.get_overlapping_areas()
		var inputObject = areas.filter(func(i): return typeof(i) == typeof(OutPutConnection))
		if inputObject.size()>0:
			input = inputObject.front();
		#if input:
			#input.numbers_received.connect(_on_numbers_received)

func _find_output():
	var posible_outputs : Array = line_2d.get_areas_at_end()
	if posible_outputs.size():
		output = posible_outputs.front()
	if output == null:
		call_deferred("queue_free")
		return false
	else:
		var outputPos = to_local(output.global_position)
		_add_point(outputPos)
	return true

func _add_point(point_position : Vector2):
	line_2d.add_line_point(point_position);
	path_2d.add_path_point(point_position);

# execution methods

func _execute():
	var delta = get_process_delta_time();
	if created:
		if not items.is_empty():
			_moveItems(delta);

func activate() :
	if waiting_delay:
		await activation_delay.timeout
	if single_item and items.size(): 
		if automatic:
			await deactivated
		else : return false
	
	if input:
		input.request_numbers()
	

func _finish_activation():
	active = true
	_turn_animation(true)
	waiting_delay = true
	activation_delay.start()
	if automatic:
		call_deferred("activate")

func deactivate():
	active = false
	_turn_animation(false)
	deactivated.emit()

func _on_numbers_received(numbers : Array[Number]):
	for i in numbers:
		path_2d.add_path_follow_node(i);
		if !items.has(i):
			items.append(i);
	if not items.is_empty():
		_finish_activation()

func _moveItems(delta):
	for i in items:
		var i_path = i.get_parent();
		if i_path is PathFollow2D:
			#i.progress += delta * 124
			i_path.progress_ratio += delta * 0.5;
			if i_path.progress_ratio == 1:
				_finishMove(i_path);

func _finishMove(node:PathFollow2D):
	var item = node.get_child(0)
	output.receive_numbers([item])
	node.queue_free()
	items.erase(item)
	if items.is_empty():
		deactivate()

func _on_line_2d_delete():
	queue_free()

func _on_line_2d_left_clicked() -> void:
	if output and created:
		activate()

func _on_activation_delay_timeout() -> void:
	waiting_delay = false
