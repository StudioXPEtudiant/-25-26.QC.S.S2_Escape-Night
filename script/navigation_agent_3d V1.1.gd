extends NavigationAgent3D

@export var patrol_speed: float = 2.0
@export var chase_speed: float = 5.0
@export var view_distance: float = 12.0
@export var lose_distance: float = 20.0

@export var patrol_points: Array[Node3D]

var current_point: int = 0
var player: Node3D
var monster: CharacterBody3D
var state: String = "patrol" # patrol / chase

func _ready():
	player = get_tree().get_first_node_in_group("player")
	monster = get_parent() # le CharacterBody3D
	path_desired_distance = 0.5
	target_desired_distance = 0.5

func _physics_process(delta):
	if player == null or monster == null:
		return

	var dist = monster.global_position.distance_to(player.global_position)

	if state == "patrol" and dist < view_distance:
		state = "chase"

	if state == "chase" and dist > lose_distance:
		state = "patrol"

	# ====== ACTION ======
	if state == "patrol":
		patrol()
	else:
		chase_player()
	move_monster()

func patrol():
	if patrol_points.size() == 0:
		return

	var target = patrol_points[current_point].global_position
	set_target_position(target)

	if monster.global_position.distance_to(target) < 1.0:
		current_point = (current_point + 1) % patrol_points.size()

func chase_player():
	set_target_position(player.global_position)

func move_monster():
	if is_navigation_finished():
		monster.velocity = Vector3.ZERO
		return

	var next_pos = get_next_path_position()
	var dir = (next_pos - monster.global_position).normalized()

	var speed = patrol_speed
	if state == "chase":
		speed = chase_speed

	monster.velocity = dir * speed
	monster.move_and_slide()
