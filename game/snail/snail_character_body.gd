extends CharacterBody2D

const SPEED = 1000
var normal: Vector2
var forward: Vector2
var next_normal: Vector2
var next_forward: Vector2

@onready var forward_node: Node2D = $"../Follower/Forward"

func _physics_process(delta: float) -> void:
	while not is_on_wall():
		velocity = 1000 * Vector2.DOWN
		move_and_slide()
		if is_on_wall():
			update_forward()

	var input := Input.get_axis("ui_left", "ui_right")
	if not input:
		velocity = Vector2.ZERO
		return
	
	var backup_pos: Vector2 = position
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		normal = collision.get_normal().normalized()
		forward = -normal.orthogonal().normalized()
		forward_node.rotation = forward.angle()
	
		velocity = SPEED * input * forward - 1 / delta * normal
		move_and_slide()
		if position != backup_pos:
			while not is_on_wall():
				velocity = -1000 * normal
				move_and_slide()
			return

func update_forward():
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		normal = collision.get_normal().normalized()
		forward = -normal.orthogonal().normalized()
		forward_node.rotation = forward.angle()
