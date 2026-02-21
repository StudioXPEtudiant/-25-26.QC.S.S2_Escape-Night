extends CharacterBody3D

@export var speed: float = 4.0
var player: Node3D
@onready var agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	agent.path_desired_distance = 0.5
	agent.target_desired_distance = 1.5

func _physics_process(delta):
	if player == null:
		return

	agent.set_target_position(player.global_position)

	if agent.is_navigation_finished():
		velocity = Vector3.ZERO
		return

	var next_pos = agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed

	move_and_slide()
