extends CharacterBody3D

@export var speed: float = 5.0
@export var detection_distance: float = 15.0

var player: Node3D
var is_attracted: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	if player == null:
		return

	check_light()

	if is_attracted:
		chase_player()
	else:
		velocity = Vector3.ZERO

	move_and_slide()

# =========================
# Détection de lumière
# =========================
func check_light():
	var distance = global_position.distance_to(player.global_position)
	if distance > detection_distance:
		is_attracted = false
		return

	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return

	var to_monster = (global_position - camera.global_position).normalized()
	var forward = -camera.global_transform.basis.z.normalized()
	var dot = forward.dot(to_monster)

	if dot > 0.8:
		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(
			camera.global_position,
			global_position
		)
		query.exclude = [camera.get_parent()]
		var result = space.intersect_ray(query)
		if result and result.collider == self:
			is_attracted = true
			return

	is_attracted = false

# =========================
# Poursuite
# =========================
func chase_player():
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed
