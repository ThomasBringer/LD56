extends Area2D

func _on_plant_entered(plant: Node2D) -> void:
	plant.set_near_player()

func _on_plant_exited(plant: Node2D) -> void:
	plant.set_near_player(false)
