extends StaticBody2D

class_name PlantPart

@export var bend_amount: float = 8

@onready var base_angle: float = rotation
@onready var player_angle: float = rotation + sign(rotation) * deg_to_rad(bend_amount)
@onready var target_angle: float = base_angle

const SPEED: float = 5

var near_player: bool = false
var bending: int = 0
func set_near_player(val: bool = true) -> void:
	near_player = val
	if val:
		bend()
	else:
		unbend()

func _physics_process(delta: float) -> void:	
	rotate_towards_target(delta)

func try_bend_parent() -> void:
	var parent: Node2D = get_parent()
	if parent.is_in_group("plantpart"):
		parent.bend()

func bend() -> void:
	bending += 1
	target_angle = player_angle
	try_bend_parent()

func try_unbend_parent() -> void:
	var parent: Node2D = get_parent()
	if parent.is_in_group("plantpart"):
		parent.unbend()

func unbend() -> void:
	bending -= 1
	if bending < 1:
		target_angle = base_angle
	try_unbend_parent()

func rotate_towards_target(delta: float) -> void:
	rotate_smooth_node(self, SPEED, delta)

func rotate_smooth_node(node: Node2D, speed: float, delta: float) -> void:
	var short: float = short_angle(node.rotation, target_angle)
	var dangle: float = short * speed * delta
	if abs(dangle) > abs(short):
		node.rotation = target_angle
	else:
		node.rotate(dangle)

func short_angle(from, to) -> float:
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
