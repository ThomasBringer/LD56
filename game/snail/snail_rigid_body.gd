extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	manage_plants(delta)

func manage_plants(delta: float) -> void:
	
	if get_contact_count() > 0:
		print("contact")
		var contacts: Array[Node2D] = get_colliding_bodies()
		var contact: Node2D = contacts[0]
		
		if contact.is_in_group("plantpart"):
			contact.on_player_here(delta)
	else:
		print("no.")
	
	for plant in get_tree().get_nodes_in_group("plantpart"):
		plant.on_player_everyone(delta)
