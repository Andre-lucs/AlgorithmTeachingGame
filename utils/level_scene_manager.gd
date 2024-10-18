extends Node

const LEVEL_SELECT_SCENE : PackedScene = preload("res://UI/LevelSelect/level_select_ui.tscn");
const LEVEL_SCENE_PATH := "res://levels/level_%d.tscn"

func goto_level_list():
	get_tree().change_scene_to_packed(LEVEL_SELECT_SCENE)

func goto_next_level(curr_level_number : int):
	var level : PackedScene = load(LEVEL_SCENE_PATH % (curr_level_number+1))
	get_tree().change_scene_to_packed(level)

func goto_level(level_number : int):
	var level : PackedScene = load(LEVEL_SCENE_PATH % level_number)
	get_tree().change_scene_to_packed(level)
