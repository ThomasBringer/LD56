extends RigidBody2D

@onready var audio_impact: AudioStreamPlayer = $"../Audio/AudioImpact"
@onready var audio_woosh: AudioStreamPlayer = $"../Audio/AudioWoosh"

var woosh_ready: bool = true
var on_ground: bool = false

func _on_collision(body: Node) -> void:
	if audio_impact.playing: return
	audio_impact.play()
	woosh_ready = true
	on_ground = true

func _physics_process(delta: float) -> void:
	if linear_velocity.y > 250 and woosh_ready and not on_ground:
		if audio_woosh.playing: return
		woosh_ready = false
		audio_woosh.play()
	
func _on_body_exited(body: Node) -> void:
	on_ground = false
