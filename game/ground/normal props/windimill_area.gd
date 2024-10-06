extends Area2D

var parent: Node2D

func _on_body_entered(body: Node2D) -> void:
	parent = body.get_parent()
	body.reparent(self)

func _on_body_exited(body: Node2D) -> void:
	body.reparent(parent)
