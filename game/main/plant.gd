extends Node2D

var point_count: int = 0
var points: Array[Node2D] = []
@onready var line: Line2D = $Line2D

func _ready() -> void:
	line.clear_points()
	search_part()
	print("point_count", point_count)

func search_part(my_parent: Node2D = self) -> void:
	for child in my_parent.get_children():
		if child.is_in_group("plantpoint"):
			line.add_point(child.global_position - line.global_position)
			points.append(child)
			point_count += 1
			search_part(child)

func _process(delta: float) -> void:
	for i in point_count:
		line.set_point_position(i, points[i].global_position - line.global_position)
