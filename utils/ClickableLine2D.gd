extends Line2D
class_name ClickableLine2D

var _pressed : bool = false;

signal clicked(button : MouseButton , global_position : Vector2, segment : int, offset : float);
signal released(button : MouseButton, inline : bool, global_position : Vector2, segment : int, offset : float);

func _input(event : InputEvent):	
	# On every right mouse click
	if event is InputEventMouseButton:
			
			# The global position where the click happened
			var mouse_click : Vector2 = get_global_mouse_position()
			
			# We calculate the squared distance, so we don't need to calculate the root for the distance of multiple vectors
			# If you want to increase the detection click range, you would do it here
			var squared_width : float = width*width
			
			# Because you also requested the offset, we can also calculate it
			var offset : float = 0
			
			# Iterate every section (points - 1 sections)
			for i in range(points.size()-1):
				# We get 2 points of the Line2D (essentialy a line) and get the closest point on that line to our mouse click
				# Don't forget to also translate the local points to the global position where the click is
				var closest_point : Vector2 = Geometry2D.get_closest_point_to_segment(mouse_click, global_position + points[i], global_position + points[i+1])
				# If the distance of the closest point and the mouse click is smaller or equal the mouse position, it was clicked within the line
				if closest_point.distance_squared_to(mouse_click) <= squared_width:
					# Do something on click
					# To our offset we add the position of the click, relative to the first point of the click, closest click is global space, points local space, so we need to transform it again
					offset += closest_point.distance_to(global_position + points[i])
					on_click(event.button_index, i, mouse_click, offset)
					return
				else:
					# The click didn't happen here, meaning the entire line segmet is added to the offset
					offset += points[i].distance_to(points[i+1])
			if _pressed and not event.pressed:
				emit_signal("released", event.button_index, false, mouse_click, -1,-1.0);
				_pressed = false;

func on_click(button : MouseButton, segment : int, global_click_position : Vector2, offset : float) -> void:
	if _pressed:
		released.emit(button, true, global_click_position, segment, offset);
		_pressed = false;
	else:
		clicked.emit(button, global_click_position, segment, offset);
		_pressed = true;
