extends Node2D

@onready var ray_cast: RayCast2D = $Remote1/RayCast
@onready var tail_point: Sprite2D = $TailPoint
@onready var raycast_2_pivot: Node2D = $Remote2/Raycast2Pivot
@onready var ray_cast_2: RayCast2D = $Remote2/Raycast2Pivot/ConstantRotation/RayCast2

var normal: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if ray_cast.is_colliding():
		normal = ray_cast.get_collision_normal()
		if normal:
			raycast_2_pivot.rotation = (-normal).angle()
			if ray_cast_2.is_colliding():
				tail_point.global_position = ray_cast_2.get_collision_point()
	#else:
		#raycast_2_pivot.rotation = (-normal).angle() - PI / 4
		#if ray_cast_2.is_colliding():
			#tail_point.global_position = ray_cast_2.get_collision_point()

#func _physics_process(delta: float) -> void:
	#if normal:
		#raycast_2_pivot.rotation = (-normal).angle()
		#tail_point.global_position = ray_cast_2.get_collision_point()
	#
	#if ray_cast.is_colliding():
		#normal = ray_cast.get_collision_normal()
	#else: normal = Vector2.ZERO
