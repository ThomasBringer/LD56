extends RigidBody2D

@onready var audio_impact: AudioStreamPlayer = $"../Audio/AudioImpact"

func _on_collision(body: Node) -> void:
	audio_impact.play()
