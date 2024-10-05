extends Node2D

@onready var ray_cast: RayCast2D = $Remote1/RayCast
@onready var tail_point: Sprite2D = $TailPoint

signal moved_tail_point

func _physics_process(delta: float) -> void:
	if ray_cast.is_colliding():
		tail_point.global_position = ray_cast.get_collision_point()
	moved_tail_point.emit()
