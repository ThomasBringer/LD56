extends Area2D

const SPEED: float = 4000
@onready var velocity: Vector2 = SPEED * Vector2.UP.rotated(global_rotation)
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	audio.play()
	anim.play("bounce")
	if body.is_in_group("snailrigid"):
		rigid_entered(body)
	else:
		character_entered(body)

func rigid_entered(body: Node2D) -> void:
	body.linear_velocity = velocity
	
func character_entered(body: Node2D) -> void:
	body.mushroom(velocity)
