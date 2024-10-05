extends CollisionPolygon2D

@onready var child = $Polygon2D

func _ready():
	child.polygon = polygon
