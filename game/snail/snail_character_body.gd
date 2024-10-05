extends CharacterBody2D

const SPEED = 750
var normal: Vector2
var forward: Vector2
var next_normal: Vector2
var next_forward: Vector2

#@onready var forward_node: Node2D = $"../Follower/Forward"
@onready var rotator_node: Node2D = $"../Follower/Rotator"
@onready var smooth_rotator: Node2D = $"../Follower/SmoothRotator"
@onready var slow_rotator: Node2D = $"../Follower/SlowRotator"
@onready var follower: Node2D = $"../Follower"

const ANGULAR_SHELL_SPEED: float = 15
const ANGULAR_SHELL_SPEED_SLOW: float = 5
var target_angle: float = 0
var input: float

#func manage_plants(delta: float) -> void:
	#var collision: KinematicCollision2D = get_last_slide_collision()
	#if collision:
		#var collider = collision.get_collider()
		#if collider.is_in_group("plantpart"):
			#collider.on_player_here(delta)
	#
	#for plant in get_tree().get_nodes_in_group("plantpart"):
		#plant.on_player_everyone(delta)

func _physics_process(delta: float) -> void:
	if not is_on_wall():
		velocity.x = 0
		velocity.y += get_gravity().y * delta
		move_and_slide()
		if is_on_wall():
			update_forward()
		return
	
	#manage_plants(delta)
	
	input = Input.get_axis("ui_left", "ui_right")
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
			target_angle = dpos.angle()
			rotator_node.rotation = target_angle
			
			#angle_vel = (angle - smooth_rotator.rotation) / ANGULAR_SHELL_DURATION
			#smooth_rotator.rotate(angle_vel * delta)
			rotate_smooth(delta)
			return

func rotate_smooth(delta: float):
	rotate_smooth_node(smooth_rotator, ANGULAR_SHELL_SPEED, delta)
	rotate_smooth_node(slow_rotator, ANGULAR_SHELL_SPEED_SLOW, delta)

func rotate_smooth_node(node: Node2D, speed: float, delta: float):
	var short: float = short_angle(node.rotation, target_angle)
	var dangle: float = short * speed * delta
	if abs(dangle) > abs(short):
		node.rotation = target_angle
	else:
		node.rotate(dangle)

func short_angle(from, to)-> float:
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func update_forward():
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		normal = collision.get_normal().normalized()
		forward = -normal.orthogonal().normalized()
		target_angle = forward.angle()
		rotator_node.rotation = target_angle

func transition(body_rotation):
	rotator_node.rotation += follower.rotation
	smooth_rotator.rotation += follower.rotation
	slow_rotator.rotation += follower.rotation
	follower.rotation = 0
