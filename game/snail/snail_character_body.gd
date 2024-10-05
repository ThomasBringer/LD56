extends CharacterBody2D

const SPEED = 1000
var normal: Vector2
var forward: Vector2
var next_normal: Vector2
var next_forward: Vector2

@onready var forward_node: Node2D = $"../Follower/Forward"
@export var ray_cast_left_array: Array[RayCast2D]
@export var ray_cast_right_array: Array[RayCast2D]
var ray_cast_array: Array[RayCast2D]

func _physics_process(delta: float) -> void:
	#print("RAY PIVOT ROTATION   ",ray_pivot.rotation)
	while not is_on_wall():
		velocity = 1000 * Vector2.DOWN
		move_and_slide()
		if is_on_wall():
			update_forward()
	#if not is_on_wall():
		#print("AIR")
		#velocity.x = 0
		#velocity += get_gravity() * delta
		#move_and_slide()
		#return

	var input := Input.get_axis("ui_left", "ui_right")
	if not input:
		velocity = Vector2.ZERO
		return
	
	update_forward()
	ray_cast_array = ray_cast_right_array if input > 0 else ray_cast_left_array
	
	var i: int = 0
	for ray_cast in ray_cast_array:
		if ray_cast.is_colliding():
			next_normal = ray_cast.get_collision_normal().normalized()
			next_forward = -next_normal.orthogonal().normalized()
			var angle: float = forward.angle_to(next_forward)
			if abs(angle)>.01: print(angle * sign(input))
			if angle * sign(input) > .1:
				velocity = SPEED * input * forward - 1 / delta * normal
				#velocity = SPEED * input * next_forward
			else:
				velocity = SPEED * input * forward - 1 / delta * normal
			
			move_and_slide()
			
			while not is_on_wall():
				print("AIR DETECT END")
				velocity = -1000 * normal
				move_and_slide()
			return
				
	print("error, no raycast worked")

func update_forward():
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		normal = collision.get_normal().normalized()
		forward = -normal.orthogonal().normalized()
		forward_node.rotation = forward.angle()
