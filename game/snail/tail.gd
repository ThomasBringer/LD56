extends Node2D

@onready var tail_ray_cast1: Node2D = $TailRayCast
@onready var tail_ray_cast2: Node2D = $TailRayCast2
@onready var tail_ray_cast3: Node2D = $TailRayCast3
@onready var tail_ray_cast4: Node2D = $TailRayCast4
@onready var tail_ray_cast5: Node2D = $TailRayCast5

@onready var point1: Node2D = $TailRayCast/TailPoint
@onready var point2: Node2D = $TailRayCast2/TailPoint
@onready var point3: Node2D = $TailRayCast3/TailPoint
@onready var point4: Node2D = $TailRayCast4/TailPoint
@onready var point5: Node2D = $TailRayCast5/TailPoint
@onready var points: Array[Node2D] = [point1, point2, point3, point4, point5]

@onready var line_trail: Line2D = $"../../../LineTrail"
@onready var head_trail: Line2D = $"../../../HeadTrail"
@onready var eye_trail_left: Line2D = $"../../../EyeTrailLeft"
@onready var eye_trail_right: Line2D = $"../../../EyeTrailRight"

@onready var head_offset: Vector2 = head_trail.get_point_position(1) - head_trail.get_point_position(0)
func get_head_offset_relative() -> Vector2:
	if last_input < 0:
		return head_offset * Vector2(-1, 1)
	return head_offset
@onready var eye_left_offset: Vector2 = eye_trail_left.get_point_position(1) - eye_trail_left.get_point_position(0)
@onready var eye_right_offset: Vector2 = eye_trail_right.get_point_position(1) - eye_trail_right.get_point_position(0)

@onready var snail: Node2D = $"../../.."

@onready var character_body: CharacterBody2D = $"../../../CharacterBody2D"

@onready var rotator: Node2D = $"../../Rotator"

const DISTANCE: float = 60
const SPEED: float = 20
const SPEED_MAX: float = 5000000000000
#const SPEED: float = 20
#const SPEED_MAX: float = 1250
var point_moved_count: int = 0
var last_delta: float
var last_input: float = 1


func _physics_process(delta: float) -> void:
	self.last_delta = delta

func _ready() -> void:
	tail_ray_cast1.moved_tail_point.connect(_on_point_moved)
	tail_ray_cast2.moved_tail_point.connect(_on_point_moved)
	tail_ray_cast3.moved_tail_point.connect(_on_point_moved)
	tail_ray_cast4.moved_tail_point.connect(_on_point_moved)
	tail_ray_cast5.moved_tail_point.connect(_on_point_moved)

func _on_point_moved():
	point_moved_count += 1
	if point_moved_count >= 5:
		point_moved_count = 0
		tidy_points()

func tidy_points():
	var highest_point_i: int = 2
	for p in points.size():
		if points[p].position.y < points[highest_point_i].position.y:
			highest_point_i = p
	
	match highest_point_i:
		0:
			tidy(point1, point2)
			tidy(point2, point3)
			tidy(point3, point4)
			tidy(point4, point5)
		1:
			tidy(point2, point1)
			tidy(point2, point3)
			tidy(point3, point4)
			tidy(point4, point5)
		2:
			tidy(point3, point2)
			tidy(point2, point1)
			tidy(point3, point4)
			tidy(point4, point5)
		3:
			tidy(point4, point5)
			tidy(point4, point3)
			tidy(point3, point2)
			tidy(point2, point1)
		4:
			tidy(point5, point4)
			tidy(point4, point3)
			tidy(point3, point2)
			tidy(point2, point1)
	
	if character_body.input < 0:
		last_input = -1
		update_tail_left()
	elif character_body.input > 0:
		last_input = 1
		update_tail_right()
	else:
		if last_input < 0: update_tail_left()
		else: update_tail_right()

func update_tail_right():
	for p in 4:
		move_point(p, p)
	var head_base: Vector2 = move_point(4, 4)
	move_head(head_base)

func update_tail_left():
	for p in range(1, 5):
		move_point(4 - p, p)
	var head_base: Vector2 = move_point(4, 0)
	move_head(head_base)

func move_head(head_base: Vector2):
	head_trail.set_point_position(0, head_base)
	var eye_base: Vector2 = move_line_point_towards(
		head_trail, 1,
		head_base +  get_head_offset_relative().rotated(rotator.rotation),
		last_delta)
	eye_trail_left.set_point_position(0, eye_base)
	eye_trail_right.set_point_position(0, eye_base)
	move_line_point_towards(eye_trail_left, 1, eye_base + eye_left_offset.rotated(rotator.rotation), last_delta)
	move_line_point_towards(eye_trail_right, 1, eye_base + eye_right_offset.rotated(rotator.rotation), last_delta)

func move_point(p1: int, p2: int):
	return move_line_point_towards(line_trail, p1, points[p2].global_position, last_delta)

func move_line_point_towards(line: Line2D, i: int, pos: Vector2, delta: float):
	var start: Vector2 = line.get_point_position(i)
	var vel: Vector2 = (pos - snail.global_position - start) * SPEED
	if vel.length() > SPEED_MAX:
		vel = SPEED_MAX * vel.normalized()
	var result: Vector2 = start + vel * delta
	line.set_point_position(i, result)
	return result
	#line.set_point_position(i, pos - snail.global_position )

func tidy(from: Node2D, to: Node2D):
	to.global_position = from.global_position + DISTANCE * (to.global_position - from.global_position).normalized()
