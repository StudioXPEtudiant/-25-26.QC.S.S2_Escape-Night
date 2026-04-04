extends CharacterBody3D

@export var speed: float = 6.0
@export var chase_music: AudioStreamPlayer3D

var target_position: Vector3
var is_chasing: bool = false

func _ready():
	start_chase()
	
func _physics_process(delta):
	update_target()
	move_to_target()
	move_and_slide()

func start_chase():
	is_chasing = true
	
	if chase_music:
		chase_music.play()
		
	print("Poursuite lancé")
	
func update_target():
	var best_target = null
	var best_distance = INF
	
	for source in get_tree().get_nodes_in_group("heat_source"):
		var dist = global_position.distance_to(source.global_pisition)
		if dist < best_distance:
			best_distance = dist
			best_target = source.global_position
			
	for source in get_tree().get_nodes_in_group("sound_source"):
		var dist = global_position.distance_to(source.global_pisition)
		if dist < best_distance:
			best_distance = dist
			best_target = source.global_position
			
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var dist = global_position.distance_to(player.global_position)
		if dist < best_distance:
			best_target = player.global_position
			
	if best_target != null:
		target_position = best_target
		
func move_to_target():
	if target_position == null:
		return
		
	var dir = (target_position - global_position).normalized()
	velocity = dir * speed
