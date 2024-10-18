@tool
extends Button


@export var level_number : int:
	set(value):
		level_number = value
		text = String.num(value)

func _get_configuration_warnings() -> PackedStringArray:
	if !ResourceLoader.exists(LevelSceneManager.LEVEL_SCENE_PATH % level_number):
		return ["Não existe nenhum nível com este número"]
	return []

func _on_pressed() -> void:
	LevelSceneManager.goto_level(level_number)
