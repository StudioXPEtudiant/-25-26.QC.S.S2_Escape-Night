extends CharacterBody3D

@export var speed: float = 6.0
@export var stop_distance: float = 1.5

var player: Node3D
var camera: Camera3D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	camera = get_viewport().get_camera_3d()

func _physics_process(delta):
	if player == null or camera == null:
		return

	if not is_visible_to_player():
		charge_player()
	else:
		velocity = Vector3.ZERO

	move_and_slide()

func is_visible_to_player() -> bool:
	var to_monster = (global_position - camera.global_position).normalized()
	var camera_forward = -camera.global_transform.basis.z.normalized()

	var dot = camera_forward.dot(to_monster)

	if dot < 0.6:
		return false

	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		camera.global_position,
		global_position
	)
	query.exclude = [camera.get_parent()]

	var result = space.intersect_ray(query)

	if result and result.collider == self:
		return true

	return false

func charge_player():
	var distance = global_position.distance_to(player.global_position)

	if distance > stop_distance:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
	else:
		velocity = Vector3.ZERO
		print("JUMPSCARE")
