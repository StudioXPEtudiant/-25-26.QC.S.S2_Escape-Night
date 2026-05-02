extends CharacterBody3D

@export var monster_type: String = "smart"
@export var speed: float = 4.0
@export var crazy_speed: float = 8.0
@export var health: int = 50
@export var is_immortal: bool = false
@export var hunger: float = 0.0
@export var hunger_increase: float = 1.0
@export var hunger_threshold: float = 10.0
@export var light_threshold: float = 7.0

var player: Node3D
var is_angry: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return

	match monster_type:
		"smart":
			update_hunger(delta)
			smart_behavior()
		"crazy":
			crazy_behavior()
		"immortal":
			chase_player()
		"weak":
			chase_player()

	move_and_slide()

func update_hunger(delta):
	hunger += hunger_increase * delta
	if not is_in_light() or hunger >= hunger_threshold:
		is_angry = true
	else:
		is_angry = false

func is_in_light() -> bool:
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return false
	var to_monster = (global_position - camera.global_position)
	var forward = -camera.global_transform.basis.z.normalized()
	return forward.dot(to_monster) > light_threshold

func smart_behavior():
	if is_angry:
		chase_player()
	else:
		velocity = Vector3.ZERO

func crazy_behavior():
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * crazy_speed

func chase_player():
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed

func take_damage(amount):
	if monster_type == "immortal" or is_immortal:
		print("Il est immortel")
		return
	health -= amount
	print("HP :", health)
	if health <= 0:
		die()

func die():
	print("Monstre mort")
	queue_free()
