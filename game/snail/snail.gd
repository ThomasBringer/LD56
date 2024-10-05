extends Node2D

@onready var rigid_body: RigidBody2D = $RigidBody2D
@onready var character_body: CharacterBody2D = $CharacterBody2D

@onready var rotators: Array[Node2D] = [$Follower/Rotator, $Follower/SmoothRotator, $Follower/SlowRotator]
var rotator_angles: PackedFloat32Array = [0, 0, 0]

var is_shelled: bool = false
var Is_Shelled: bool:
	get:
		return is_shelled
	set(val):
		is_shelled = val
		#save_rotations()
		if val:
			rigid_body.rotation = 0
			rigid_body.linear_velocity = Vector2.ZERO
			rigid_body.angular_velocity = 0
			
			remove_child(character_body)
			rigid_body.position = character_body.position
			add_child(rigid_body)
		else:
			
			remove_child(rigid_body)
			character_body.position = rigid_body.position
			add_child(character_body)
			character_body.transition(rigid_body.rotation)
		#load_rotations()
		#character_body.reset_angle()

func _ready() -> void:
	remove_child(rigid_body)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Is_Shelled = true
	elif event.is_action_released("ui_accept"):
		Is_Shelled = false

func _process(delta: float) -> void:
	pass
	
func save_rotations():
	for r in rotators.size():
		print("bb ",rotators[r].global_rotation)
		rotator_angles[r] = rotators[r].global_rotation

func load_rotations():
	for r in rotators.size():
		print("aa ",rotators[r].global_rotation)
		rotators[r].global_rotation = rotator_angles[r]
