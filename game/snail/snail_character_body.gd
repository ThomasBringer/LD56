extends CharacterBody2D

const SPEED = 750
var normal: Vector2
var forward: Vector2

#@onready var forward_node: Node2D = $"../Follower/Forward"
@onready var rotator_node: Node2D = $"../Follower/Rotator"
@onready var smooth_rotator: Node2D = $"../Follower/SmoothRotator"
@onready var slow_rotator: Node2D = $"../Follower/SlowRotator"
@onready var follower: Node2D = $"../Follower"

const ANGULAR_SHELL_SPEED: float = 10
const ANGULAR_SHELL_SPEED_SLOW: float = 5
var target_angle: float = 0
var input: float

@onready var audio_impact: AudioStreamPlayer = $"../Audio/AudioImpact"
@onready var audio_slither: AudioStreamPlayer = $"../Audio/AudioSlither"
@onready var audio_woosh: AudioStreamPlayer = $"../Audio/AudioWoosh"
@onready var audio_out_shell: AudioStreamPlayer = $"../Audio/AudioOutShell"

var started_falling: bool = true

var input_multiplier: int = 1
var slithering: bool = false
var on_boundary: bool = false

@onready var snail: Node2D = $".."
var boundary_left: Node2D:
	get:
		return snail.boundary_left
var boundary_right: Node2D:
	get:
		return snail.boundary_right
@onready var b_left: float = boundary_left.global_position.x + 125
@onready var b_right: float = boundary_right.global_position.x - 125

enum WALLED { ON_WALL, ON_STOPPER, IN_AIR }
var first_sound_impact: bool = true
var last_wall_collision: KinematicCollision2D
var last_nonzero_input: float = 1

func _physics_process(delta: float) -> void:
	match is_on_wall_no_stopper():
		WALLED.IN_AIR:
			if not started_falling:
				started_falling = true
				#if not first_sound_impact: 
					#audio_woosh.play()
			velocity.x = 0
			velocity.y += get_gravity().y * delta
			move_and_slide()
			if is_on_wall():
				if not audio_out_shell.playing:
					if first_sound_impact:
						first_sound_impact = false
					else:
						audio_impact.play()
				if slithering and not audio_slither.playing:
					audio_slither.play()
				update_forward()
			else:
				clamp_pos()
				return
		#WALLED.ON_STOPPER:
			#pass
		
	started_falling = false
	#manage_plants(delta)
	
	input = Input.get_axis("move_left", "move_right") * input_multiplier
	if input: last_nonzero_input = input
	#if not input:
		#velocity = Vector2.ZERO
		#rotate_smooth(delta)
		#return

	var backup_pos: Vector2 = position

	try_stop_slither_stopper()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		if not collision.get_collider().is_in_group("stopper"):
			if move(collision, delta, backup_pos) or input == 0:
				return
	
	if last_wall_collision:
		if move(last_wall_collision, delta, backup_pos, false) or input == 0:
			return
	
	clamp_pos()

func try_stop_slither_stopper():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("stopper"):
			audio_slither.stop()
			return
	if slithering and not audio_slither.playing:
		audio_slither.play()

func move(col: KinematicCollision2D, delta: float, backup_pos: Vector2, rot: bool = true) -> bool:
	last_wall_collision = col
	normal = col.get_normal().normalized()
	forward = -normal.orthogonal().normalized()
	#forward_node.rotation = forward.angle()

	if input:
		velocity = SPEED * input * forward - 1 / delta * normal
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		rotate_smooth(delta)
		velocity = - 1 / delta * normal
		move_and_slide()
	
	while not is_on_wall():
		velocity = -1000 * normal
		move_and_slide()
	#if input:
		#var dpos: Vector2 = (position - backup_pos) * sign(input)
		#if dpos.length_squared() < 10:
			#audio_slither.stop()
	if input and rot:
		#var dpos: Vector2 = (position - backup_pos) * sign(input)
		#if dpos:
		#print("target: ", forward)
		target_angle = forward.angle()
		rotator_node.rotation = target_angle
		rotate_smooth(delta)
	clamp_pos()
	return  position != backup_pos
	#if position != backup_pos:
		#return true
	#return false

func clamp_pos():
	on_boundary = position.x < b_left or position.x > b_right
	if on_boundary:
		audio_slither.stop()
		position.x = clamp(position.x, b_left, b_right)

func _input(event):
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		slithering = true
		if is_on_wall_no_stopper() == WALLED.ON_WALL:
			audio_slither.play()
	elif (event.is_action_released("move_left") and not Input.is_action_pressed("move_right")) or (event.is_action_released("move_right") and not Input.is_action_pressed("move_left")):
		slithering = false
		audio_slither.stop()

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

func is_on_wall_no_stopper() -> WALLED:
	var base_walled: bool = is_on_wall()
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		if collision.get_collider().is_in_group("stopper"):
			return WALLED.ON_STOPPER
	if base_walled: return WALLED.ON_WALL
	else: return WALLED.IN_AIR

func transition(body_rotation):
	rotator_node.rotation += follower.rotation
	smooth_rotator.rotation += follower.rotation
	slow_rotator.rotation += follower.rotation
	follower.rotation = 0
	first_sound_impact = false
