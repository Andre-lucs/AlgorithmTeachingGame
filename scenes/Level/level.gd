@tool
class_name Level extends Node2D

const ON_EXIT_LEVEL_SCENE : String = "res://UI/MainMenu/main_menu.tscn"

@export var level_info : LevelInfo 
@export var level_tests : Array[LevelTest]
@onready var solution : Solution = $Solution
@onready var ui_root: UIRoot = $UI/UIRoot
@onready var main_conveyor: MainConveyor = $MainConveyor
@onready var deposit: Deposit = $Deposit

var recieved_results : Array[Number]
var displayed_test :LevelTest

func _init() -> void:
	update_configuration_warnings()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	var children = get_children()
	ui_root.set_level_text(level_info.prompt)
	ui_root.play_button.connect("pressed", play)
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

func _on_end_level_pop_up_exit_level() -> void:
	get_tree().change_scene_to_file(ON_EXIT_LEVEL_SCENE)



func play():
	var conn := Connections.has_connections(main_conveyor)
	if !conn:
		push_error("main_conveyor does not have a connection")
		return
	conn.activate_out_connections()
