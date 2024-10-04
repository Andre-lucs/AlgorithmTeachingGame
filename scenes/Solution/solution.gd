extends Node2D
class_name Solution

var items : Array[Node2D] = []
const NUMBER = preload("res://scenes/Number/Number.tscn")
var is_playing := false


func create_object(scene:PackedScene, position:Vector2):
  var obj = scene.instantiate()
  obj.position = position
  add_child(obj)
  items.append(obj)
