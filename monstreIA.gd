extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@export var target_node: Node3D # Glissez la cible ici
@export var speed = 5.0

func _physics_process(delta):
	if target_node:
		# Mettre à jour la cible de l'agent
		nav_agent.target_position = target_node.global_position
	
	if nav_agent.is_navigation_finished():
		return

	# Obtenir la prochaine position sur le chemin
	var next_path_pos = nav_agent.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_pos) * speed
	
	velocity = new_velocity
	move_and_slide()
