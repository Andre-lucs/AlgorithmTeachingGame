extends Path2D

func _init():
	curve = Curve2D.new()

func add_path_point(pointPosition):
	(curve as Curve2D).add_point(pointPosition);

func add_path_follow_node(node:Number):
	var path_follow := PathFollow2D.new();
	path_follow.loop = false;
	add_child(path_follow);
	if node.is_inside_tree():
		node.reparent(path_follow);
	else:
		path_follow.add_child(node);
	node.position = Vector2.ZERO;
