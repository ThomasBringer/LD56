extends Node2D

@onready var rigid_body: RigidBody2D = $RigidBody2D
@onready var character_body: CharacterBody2D = $CharacterBody2D

@onready var audio_out_shell: AudioStreamPlayer = $Audio/AudioOutShell
@onready var audio_in_shell: AudioStreamPlayer = $Audio/AudioInShell
@onready var audio_slither: AudioStreamPlayer = $Audio/AudioSlither

@onready var head: Node2D = $Head

@onready var camera: Camera2D = $Follower/Camera2D

@export var boundary_left: Node2D
@export var boundary_right: Node2D
@export var boundary_down: Node2D

const CAM_MARGIN: float = 170

var is_shelled: bool = false
var Is_Shelled: bool:
	get:
		return is_shelled
	set(val):
		if val == is_shelled: return
		is_shelled = val
		if val:
			
			rigid_body.woosh_ready = true
			audio_slither.stop()
			head.z_index = 0
			audio_in_shell.play()
			
			rigid_body.rotation = 0
			rigid_body.linear_velocity = character_body.velocity
			rigid_body.angular_velocity = 0
			
			remove_child(character_body)
			rigid_body.position = character_body.position
			add_child(rigid_body)
		else:
			head.z_index = 2
			audio_out_shell.play()
			
			remove_child(rigid_body)
			character_body.position = rigid_body.position
			add_child(character_body)
			character_body.transition(rigid_body.rotation)

func _ready() -> void:
	camera.limit_left = boundary_left.global_position.x - CAM_MARGIN
	camera.limit_right = boundary_right.global_position.x + CAM_MARGIN
	camera.limit_bottom = boundary_down.global_position.y + CAM_MARGIN
	remove_child(rigid_body)

func _input(event):
	if event.is_action_pressed("shell"):
		Is_Shelled = true
	elif event.is_action_released("shell"):
		Is_Shelled = false
