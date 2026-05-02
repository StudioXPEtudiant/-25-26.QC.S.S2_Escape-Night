extends CharacterBody3D

enum MonsterType {
	ALLY_SPIRIT,
	DIURNAL,       
	IMMORTAL,    
	WEAK,          
	CRAZY         
}

@export var monster_type: MonsterType = MonsterType.DIURNAL
@export var speed: float = 4.0
@export var health: int = 50
@export var follow_distance: float = 2.5
@export var heal_amount: int = 5
@export var heal_cooldown: float = 5.0
@export var alert_radius: float = 12.0
@export var heal_radius: float = 4.0
@export var day_start_hour: float = 6.0
@export var day_end_hour: float = 20.0
@export var current_hour: float = 12.0  # à connecter à ton système jour/nuit
@export var detection_radius: float = 15.0
@export var regen_delay: float = 4.0
@export var regen_speed: float = 20.0
@export var flee_speed: float = 6.0
@export var flee_threshold: float = 0.5
@export var charge_speed: float = 9.0
@export var chaos_factor: float = 0.4
@export var direction_change_time: float = 1.2

var player: Node3D
var max_health: int
var is_dead: bool = false
var regen_timer: float = 0.0
var is_regenerating: bool = false
var is_fleeing: bool = false
var current_dir: Vector3 = Vector3.ZERO
var dir_timer: float = 0.0
var heal_timer: float = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	max_health = health
	randomize()
	if monster_type == MonsterType.CRAZY:
		pick_crazy_direction()

func _physics_process(delta):
	if player == null:
		return

	match monster_type:
		MonsterType.ALLY_SPIRIT:
			behavior_ally_spirit(delta)

		MonsterType.DIURNAL:
			behavior_diurnal(delta)

		MonsterType.IMMORTAL:
			behavior_immortal(delta)

		MonsterType.WEAK:
			behavior_weak()

		MonsterType.CRAZY:
			behavior_crazy(delta)

	if monster_type != MonsterType.ALLY_SPIRIT:
		move_and_slide()


func behavior_ally_spirit(delta):
	var t = Time.get_ticks_msec() * 0.001
	var offset = Vector3(sin(t) * follow_distance, 1.5, cos(t) * follow_distance)
	global_position = global_position.lerp(player.global_position + offset, delta * 3.0)

	# Détection des ennemis proches
	for monster in get_tree().get_nodes_in_group("monster"):
		if monster == self:
			continue
		if global_position.distance_to(monster.global_position) < alert_radius:
			print("Esprit : Ennemi proche !")

	heal_timer -= delta
	if heal_timer <= 0.0:
		if global_position.distance_to(player.global_position) < heal_radius:
			if player.has_method("heal"):
				player.heal(heal_amount)
				print("Esprit : +", heal_amount, " HP soignés")
		heal_timer = heal_cooldown

func behavior_diurnal(_delta):
	var is_daytime = current_hour >= day_start_hour and current_hour < day_end_hour

	if not is_daytime:
		velocity = Vector3.ZERO
		return

	var dist = global_position.distance_to(player.global_position)
	if dist < detection_radius:
		chase_player(speed)
	else:
		# Patrouille légère
		var t = Time.get_ticks_msec() * 0.001
		velocity = Vector3(sin(t) * speed * 0.3, 0.0, 0.0)

func behavior_immortal(delta):
	if is_dead:
		velocity = Vector3.ZERO
		regen_timer -= delta

		if regen_timer <= 0.0 and not is_regenerating:
			is_regenerating = true
			print("Immortel : régénération...")

		if is_regenerating:
			health += regen_speed * delta
			if health >= max_health:
				health = max_health
				is_dead = false
				is_regenerating = false
				print("Immortel : de retour !")
		return

	chase_player(speed)

func behavior_weak():
	var dist = global_position.distance_to(player.global_position)

	if is_fleeing:
		var dir = (global_position - player.global_position).normalized()
		velocity = dir * flee_speed
	elif dist < detection_radius:
		chase_player(speed)
	else:
		velocity = Vector3.ZERO

func behavior_crazy(delta):
	dir_timer -= delta
	if dir_timer <= 0.0:
		pick_crazy_direction()

	velocity = current_dir * charge_speed

func pick_crazy_direction():
	dir_timer = direction_change_time
	var to_player = (player.global_position - global_position).normalized()
	var random_dir = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
	current_dir = (to_player * (1.0 - chaos_factor) + random_dir * chaos_factor).normalized()

func chase_player(spd: float):
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * spd

func take_damage(amount: int):
	if monster_type == MonsterType.ALLY_SPIRIT:
		print("L'esprit ne peut pas être blessé")
		return

	if monster_type == MonsterType.IMMORTAL and is_dead:
		return

	health -= amount
	print(MonsterType.keys()[monster_type], " HP :", health)
	
	if monster_type == MonsterType.WEAK:
		if float(health) / float(max_health) < flee_threshold:
			is_fleeing = true
			print("Fragile : fuite !")

	if health <= 0:
		die()

func die():
	match monster_type:
		MonsterType.IMMORTAL:
			is_dead = true
			regen_timer = regen_delay
			is_regenerating = false
			print("Immortel : tombé... pas pour longtemps.")

		MonsterType.ALLY_SPIRIT:
			print("L'esprit ne peut pas mourir")
		_:
			print(MonsterType.keys()[monster_type], " : mort")
			queue_free()
