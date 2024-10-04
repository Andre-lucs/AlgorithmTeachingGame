extends ClickableLine2D

@onready var area_2d = $EndArea2D
signal delete
signal activate

func add_line_point(pointPosition: Vector2, index: int = -1):
	area_2d.position = pointPosition;
	add_point(pointPosition, index);

func get_areas_at_end():
	return area_2d.get_overlapping_areas()

func _on_clicked(button: MouseButton, _global_position, _segment, _offset):
	if button == MOUSE_BUTTON_LEFT:
		activate.emit()
	if button == MOUSE_BUTTON_RIGHT:
		default_color = Color.RED;
		material.set_shader_parameter("default_color", Color.RED)

func _on_released(button: MouseButton,inline, _global_position, _segment, _offset):
	if button == MOUSE_BUTTON_RIGHT:
		if inline:
			delete.emit()
		else:
			default_color = Color.WHITE;
			material.set_shader_parameter("default_color", Color.WHITE)
