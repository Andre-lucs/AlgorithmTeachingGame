extends CanvasLayer
class_name EndLevelPopUp

signal exit_level()
signal next_level()

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_popup_hide() -> void:
	LevelSceneManager.goto_level_list()
	exit_level.emit()

func _on_next_level_pressed() -> void:
	LevelSceneManager.goto_next_level(1)
	next_level.emit()

func popup():
	show()
	animation_player.play("popup")
