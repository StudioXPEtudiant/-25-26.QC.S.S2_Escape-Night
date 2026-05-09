extends CharacterBody3D

@export var speed: float = 6.0
@export var stop_distance: float = 0.5
@export var chase_music: AudioStreamPlayer3D

const GRAVITY: float = 9.8

var target_position: Vector3 = Vector3.ZERO
var has_target: bool = false
var is_chassing: bool = false

func _ready():
	await get_tree().process_frame
	start_chase()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	update_target()
	move_to_target()
	move_and_slide()

func start_chase():
	is_chassing = true
	if chase_music:
		chase_music.play()
	print("Poursuite lancée")

func update_target():
	var best_target = null
	var best_distance = INF

	for source in get_tree().get_nodes_in_group("heat source"):
		var dist = global_position.distance_to(source.global_position)

		if dist < best_distance:
			best_distance = dist
			best_target = source.global_position

	var player = get_tree().get_first_node_in_group("player")

	if player:
		var dist = global_position.distance_to(player.global_position)

		if dist < best_distance:
			best_distance = dist
			best_target = player.global_position

	if best_target != null:
		target_position = best_target
		has_target = true
	else:
		has_target = false

func move_to_target():
	if not has_target:
		velocity.x = 0
		velocity.z = 0
		return

	if global_position.distance_to(target_position) < stop_distance:
		velocity.x = 0
		velocity.z = 0
		return
		
	var dir = (target_position - global_position).normalized()
	
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
