extends Area2D

@onready var collect: AnimationPlayer = $Collect

var done: bool = false
@onready var bz_audio: AudioStreamPlayer2D = $BzAudio

func _on_body_entered(body: Node2D) -> void:
	if done:
		return
	done = true
	set_deferred("disabled", true)
	collect.play("collect")
	remove_child(bz_audio)
