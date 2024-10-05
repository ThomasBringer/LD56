extends Node2D

@onready var ray_cast: RayCast2D = $Remote1/RayCast
@onready var tail_point: Sprite2D = $TailPoint
@onready var snail: Node2D = $"../../../.."
@onready var character_body: CharacterBody2D = $"../../../../CharacterBody2D"

signal moved_tail_point

func _physics_process(delta: float) -> void:
	if snail.is_shelled: return
	if not character_body.is_on_wall():
		tail_point.position = Vector2.ZERO
		return
	if ray_cast.is_colliding():
		tail_point.global_position = ray_cast.get_collision_point()
	moved_tail_point.emit()
