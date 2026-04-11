extends CharacterBody3D

@export var speed_patrol: float = 2.0
@export var speed_chase: float = 5.0
@export var view_distance: float = 10.0
@export var lose_distance: float = 15.0
@export var patrol_points: Array[Node3D]

const GRAVITY: float = 9.8

var current_point: int = 0
var player: Node3D
var chasing: bool = false
var nav: NavigationAgent3D 

func _ready():
	player = get_tree().get_first_node_in_group("player")

	if not has_node("NavigationAgent3D"):
		nav = NavigationAgent3D.new()
		add_child(nav)
	else:
		nav = $NavigationAgent3D

func _physics_process(delta):
	if player == null:
		return

	# Gravité
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	var distance = global_position.distance_to(player.global_position)

	if distance < view_distance and has_line_of_sight():
		chasing = true
	elif distance > lose_distance:
		chasing = false

	if chasing:
		chase_player()
	else:
		patrol()

	move_and_slide()

func has_line_of_sight() -> bool:
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position + Vector3.UP * 0.5, 
		player.global_position + Vector3.UP * 0.5  
	)
	query.exclude = [self] 
	var result = space.intersect_ray(query)

	if result and result.collider == player:
		return true
	return false

func patrol():
	if patrol_points.size() == 0:
		velocity.x = 0
		velocity.z = 0
		return

	var target = patrol_points[current_point].global_position
	nav.target_position = target

	var next = nav.get_next_path_position()
	var dir = (next - global_position).normalized()
	velocity.x = dir.x * speed_patrol
	velocity.z = dir.z * speed_patrol

	if global_position.distance_to(target) < 0.5:
		current_point = (current_point + 1) % patrol_points.size()

func chase_player():
	nav.target_position = player.global_position

	var next = nav.get_next_path_position()
	var dir = (next - global_position).normalized()
	velocity.x = dir.x * speed_chase
	velocity.z = dir.z * speed_chase
