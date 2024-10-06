extends Node2D

@onready var rigid_body: RigidBody2D = $RigidBody2D
@onready var character_body: CharacterBody2D = $CharacterBody2D

@onready var audio_out_shell: AudioStreamPlayer = $Audio/AudioOutShell
@onready var audio_in_shell: AudioStreamPlayer = $Audio/AudioInShell

@onready var head: Node2D = $Head

var is_shelled: bool = false
var Is_Shelled: bool:
	get:
		return is_shelled
	set(val):
		is_shelled = val
		if val:
			head.z_index = 0
			audio_in_shell.play()
			
			rigid_body.rotation = 0
			rigid_body.linear_velocity = Vector2.ZERO
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
	remove_child(rigid_body)

func _input(event):
	if event.is_action_pressed("shell"):
		Is_Shelled = true
	elif event.is_action_released("shell"):
		Is_Shelled = false
