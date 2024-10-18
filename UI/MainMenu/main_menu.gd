extends Control

func _on_play_btn_pressed() -> void:
	LevelSceneManager.goto_level_list()

func _on_exit_btn_pressed() -> void:
	get_tree().quit()
