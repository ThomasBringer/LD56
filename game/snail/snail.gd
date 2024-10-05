extends Node2D

@onready var rigid_body: RigidBody2D = $RigidBody2D
@onready var character_body: CharacterBody2D = $CharacterBody2D

var is_shelled: bool = false
var Is_Shelled: bool:
	get:
		return is_shelled
	set(val):
		is_shelled = val
		if val:
			remove_child(character_body)
			rigid_body.position = character_body.position
			add_child(rigid_body)
		else:
			remove_child(rigid_body)
			character_body.position = rigid_body.position
			add_child(character_body)

func _ready() -> void:
	remove_child(rigid_body)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Is_Shelled = true
	elif event.is_action_released("ui_accept"):
		Is_Shelled = false

func _process(delta: float) -> void:
	pass
