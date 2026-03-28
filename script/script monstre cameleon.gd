extends CharacterBody3D

@export var speed_calm: float = 2.0
@export var speed_angry: float = 5.0

@export var hunger_increase: float = 1.0
@export var hunger_threshold: float = 10.0

@export var light_threshold: float = 0.7

var player: Node3D
var hunger: float = 0.0
var is_angry: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return

	update_hunger(delta)
	check_environment()
	behave()

	move_and_slide()

func update_hunger(delta):
	hunger += hunger_increase * delta

func check_environment():
	var in_light = is_in_light()
	var is_hungry = hunger > hunger_threshold

	if not in_light or is_hungry:
		is_angry = true
	else:
		is_angry = false

func is_in_light() -> bool:
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return false

	var to_monster = (global_position - camera.global_position).normalized()
	var forward = -camera.global_transform.basis.z.normalized()

	var dot = forward.dot(to_monster)

	return dot > light_threshold

func behave():
	if is_angry:
		chase_player()
	else:
		stay_calm()

func chase_player():
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed_angry

func stay_calm():
	velocity = Vector3.ZERO
	look_at(player.global_position, Vector3.UP)
