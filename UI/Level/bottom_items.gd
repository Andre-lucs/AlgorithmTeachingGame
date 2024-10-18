@tool
extends CanvasLayer


@onready var bottom_container: HBoxContainer = $BottomItems/Control/HBoxContainer

var currentTween : Tween

@export var level_text : String:
	set(value):
		level_text = value
		%LevelText.text = value
@export_group("Animation properties")
@export var transition_type : Tween.TransitionType
@export var ease_type : Tween.EaseType
@export var move_amount := 120.0
@export var duration := .2


func _on_hover_detect_mouse_entered() -> void:
	if currentTween and currentTween.is_running() :
		await currentTween.finished
	currentTween = create_tween()
	currentTween.tween_property(bottom_container, "position", Vector2(0,0), duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)

func _on_hover_detect_mouse_exited() -> void:
	if currentTween.is_running() :
		await currentTween.finished
	currentTween = create_tween()
	currentTween.tween_property(bottom_container, "position", Vector2(0,move_amount), duration).set_delay(duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
