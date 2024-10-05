extends StaticBody2D

class_name PlantPart

@onready var base_angle: float = rotation
@onready var player_angle: float = 2 * rotation
@onready var target_angle: float = base_angle

const SPEED: float = 5

var near_player: bool = false
var bending: int = 0
func set_near_player(val: bool = true) -> void:
	near_player = val
	print("set near player ", name," b ", bending, " near player ",near_player)
	if val:
		bend()
	else:
		unbend()

func _physics_process(delta: float) -> void:
	#print("________________target_angle ",target_angle)
	
	rotate_towards_target(delta)

func try_bend_parent() -> void:
	var parent: Node2D = get_parent()
	if parent.is_in_group("plantpart"):
		parent.bend()

func bend() -> void:
	bending += 1
	target_angle = player_angle # base_angle + (player_angle - base_angle) *.5 # / float(2 ** depth)
	#print("target_angle3 ",target_angle)
	try_bend_parent()
	print("Bend ", name," b ", bending, " near player ",near_player)

func try_unbend_parent() -> void:
	var parent: Node2D = get_parent()
	if parent.is_in_group("plantpart"):
		parent.unbend()

func unbend() -> void:
	bending -= 1
	if bending < 1:
		#print("target_angle4 ",target_angle)
		print("unbend, not near player ", name)
		target_angle = base_angle
	try_unbend_parent()
	print("Unbend ", name," b ", bending, " near player ",near_player)

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
