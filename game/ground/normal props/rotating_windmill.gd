extends Node2D

const ANGULAR_SPEED = 30
const ANGULAR_SPEED_RAD = deg_to_rad(ANGULAR_SPEED)

@onready var windmill: StaticBody2D = $Windmill

func _physics_process(delta: float) -> void:
	windmill.rotate(- ANGULAR_SPEED_RAD * delta)
