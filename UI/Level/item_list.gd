class_name ObjectsItemList extends ItemList

signal can_place_conveyour(value : bool)

var available_items : Array[ItemListItem] = [] :
	set(value):
		available_items = value
		while item_count:
			remove_item(0)
		for item in available_items:
			add_item(item.item_text, item.item_icon)

var _local_can_place_conveyour := false;

func _get_drag_data(_at_position: Vector2) -> Variant:
	if get_selected_items().size():
		var selected_index = get_selected_items()[0];
		set_drag_preview(get_preview_node(selected_index));
		deselect_all()
		return available_items[selected_index].item_scene;
	else:
		return null;


func get_preview_node(selected_index: int):
	var preview := Control.new()
	var preview_texture := TextureRect.new();
	var selected_icon = available_items[selected_index].item_icon;
	preview_texture.texture = selected_icon;
	preview_texture.scale *= 4
	preview_texture.position = Vector2(preview_texture.texture.get_width(), preview_texture.texture.get_width()) * -2
	preview.add_child(preview_texture)
	preview.modulate.a = .6
	return preview


func _on_item_selected(index: int) -> void:
	if available_items[index].item_text == "Esteira":
		_local_can_place_conveyour = true;
		can_place_conveyour.emit(true)
		return
	elif _local_can_place_conveyour:
		_local_can_place_conveyour = false;
		can_place_conveyour.emit(false)
