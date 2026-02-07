extends CharacterBody3D

@export var speed_patrol: float = 2.0
@export var speed_chase: float = 5.0
@export var view_distance: float = 10.0
@export var lose_distance: float = 15.0
@export var patrol_points: Array[Node3D]

var current_point: int = 0
var player: Node3D
var chasing: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance < view_distance:
		chasing = true
	elif distance > lose_distance:
		chasing = false

	if chasing:
		chase_player()
	else:
		patrol()

	move_and_slide()

func patrol():
	if patrol_points.size() == 0:
		return

	var target = patrol_points[current_point].global_position
	var dir = (target - global_position).normalized()
	velocity = dir * speed_patrol

	if global_position.distance_to(target) < 0.5:
		current_point = (current_point + 1) % patrol_points.size()

func chase_player():
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed_chase
