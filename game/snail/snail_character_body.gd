extends CharacterBody2D

const SPEED = 1000
var normal: Vector2
var forward: Vector2
var next_normal: Vector2
var next_forward: Vector2

#@onready var forward_node: Node2D = $"../Follower/Forward"
@onready var rotator_node: Node2D = $"../Follower/Rotator"
@onready var smooth_rotator: Node2D = $"../Follower/SmoothRotator"

const ANGULAR_SHELL_SPEED: float = 15
var angle: float = 0

func _physics_process(delta: float) -> void:
	while not is_on_wall():
		velocity = 1000 * Vector2.DOWN
		move_and_slide()
		if is_on_wall():
			update_forward()

	var input := Input.get_axis("ui_left", "ui_right")
	if not input:
		velocity = Vector2.ZERO
		rotate_smooth(delta)
		return
	
	var backup_pos: Vector2 = position
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		normal = collision.get_normal().normalized()
		forward = -normal.orthogonal().normalized()
		#forward_node.rotation = forward.angle()
	
		velocity = SPEED * input * forward - 1 / delta * normal
		
		move_and_slide()
		if position != backup_pos:
			while not is_on_wall():
				velocity = -1000 * normal
				move_and_slide()
			var dpos: Vector2 = (position - backup_pos) * sign(input)
			angle = dpos.angle()
			rotator_node.rotation = angle
			
			#angle_vel = (angle - smooth_rotator.rotation) / ANGULAR_SHELL_DURATION
			#smooth_rotator.rotate(angle_vel * delta)
			rotate_smooth(delta)
			return

	
func rotate_smooth(delta: float):
	var short: float = short_angle(smooth_rotator.rotation, angle)
	var dangle: float = short * ANGULAR_SHELL_SPEED * delta
	if abs(dangle) > abs(short):
		smooth_rotator.rotation = angle
	else:
		smooth_rotator.rotate(dangle)

func short_angle(from, to)-> float:
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func update_forward():
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		normal = collision.get_normal().normalized()
		forward = -normal.orthogonal().normalized()
		rotator_node.rotation = forward.angle()
		smooth_rotator.rotation = forward.angle()
