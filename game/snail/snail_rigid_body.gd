extends RigidBody2D

@onready var audio_impact: AudioStreamPlayer = $"../Audio/AudioImpact"
@onready var audio_woosh: AudioStreamPlayer = $"../Audio/AudioWoosh"

var woosh_ready: bool = true
var on_ground: bool = false

const FULL_VOLUME_VELOCITY: float = 2500
var last_vel: Vector2 = Vector2.ZERO

func _on_collision(body: Node) -> void:
	if audio_impact.playing: return
	audio_impact.volume_db = lerp(-15, 0, last_vel.length()/FULL_VOLUME_VELOCITY)
	audio_impact.play()
	woosh_ready = true
	on_ground = true

func _physics_process(delta: float) -> void:
	last_vel = linear_velocity
	if linear_velocity.y > 250 and woosh_ready and not on_ground:
		if audio_woosh.playing: return
		woosh_ready = false
		audio_woosh.play()
	
func _on_body_exited(body: Node) -> void:
	on_ground = false

func _on_audio_impact_finished() -> void:
	audio_impact.volume_db = 0
