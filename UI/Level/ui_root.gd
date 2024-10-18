class_name UIRoot extends Control

signal create_object(scene:PackedScene , position:Vector2)
signal play

@onready var item_list: ObjectsItemList = $MarginContainer/ObjectsList
@onready var end_level_pop_up: EndLevelPopUp = $EndLevelPopUp
@onready var level_text: RichTextLabel = $BottomItems/BottomItems/Control/HBoxContainer/LevelText
@onready var play_button: Button = $BottomItems/BottomItems/Control/HBoxContainer/VBoxContainer/PlayButton

@export var objects_list : ObjectsList

var available_objects : Array[ItemListItem] = []

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == typeof(PackedScene) 

func  _drop_data(at_position: Vector2, data: Variant) -> void:
	create_object.emit(data as PackedScene, at_position);

func show_success_message():
	end_level_pop_up.popup()

func show_wrong_ans_message():
	print("erradooooo")

func set_available_objects(objects : Array[ObjectsList.OBJECTS]):
	for i in objects_list.Objects.size():
		if objects.has(i):
			available_objects.append(objects_list.Objects[i])
	
	item_list.available_items = available_objects

func set_level_text(value :String):
	print(value)
	if level_text:
		level_text.text= value
	else:
		$BottomItems/BottomItems/Control/HBoxContainer/LevelText.text = value;

func _on_play_button_pressed() -> void:
	play.emit()
