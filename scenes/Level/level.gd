@tool
class_name Level extends Node2D

@export var level_info : LevelInfo 
@export var level_tests : Array[LevelTest]

@onready var solution : Solution = $Solution
var main_conveyor: MainConveyor
var deposit: Deposit
@onready var ui_root: UIRoot = $UI/UIRoot

var recieved_results : Array[Number]
var displayed_test :LevelTest

func _init() -> void:
	update_configuration_warnings()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	var children = get_children()
	main_conveyor = children.filter(func (i) : return i is MainConveyor).front()
	deposit = children.filter(func (i) : return i is Deposit).front()
	deposit.validate.connect(_on_deposit_validate)
	displayed_test = level_tests.pick_random()
	main_conveyor.numbers = displayed_test.inputs
	ui_root.set_available_objects(level_info.available_objects)

func _on_ui_root_create_object(scene: PackedScene, position: Vector2) -> void:
	solution.create_object(scene, position)

func _on_deposit_validate(number: Number) -> void:
	recieved_results.append(number)
	for i in recieved_results.size():
		if recieved_results[i].value != displayed_test.results[i]:
			ui_root.show_wrong_ans_message()
			return
	
	if recieved_results.size() == displayed_test.results.size():
		ui_root.show_success_message()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if !get_children().any(func(i): return i is MainConveyor):
		warnings.append("The level needs a MainConveyor")
	if !get_children().any(func(i): return i is Deposit):
		warnings.append("The level needs a Deposit")
	return warnings
