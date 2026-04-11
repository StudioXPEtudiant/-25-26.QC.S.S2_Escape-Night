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
@export var current_hour: float = 12.0
@export var detection_radius: float = 15.0
@export var regen_dealy: float = 4.0
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
var is_feeling: bool = false
var current_dir: Vector3 = Vector3.ZERO
var dir_timer: float = 0.0

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
		
func behavior_ally_sprint(delta):
	var t = Time.get_ticks_msec() * 0.001
	var offest = Vector3(sin(t) * follow_distance, 1.5, cos(t) * follow_distance)
	global_position = global_position.lerp(player.global_position + offest, delta * 3.0)
	
	for monster in get_tree().get_first_node_in_group("monster"):
		if monster == self:
			continue
		if global_position.distance_to(monster.global_position) < alert_radius:
			print("Esprit: Ennemi proche!")
			
	heal_timer -= delta
	if heal_timer <= 0.0:
		if global_position.distance_to(player.global_position) < heal_radius:
			if player.has_method("heal"):
				player.heal(heal_amount)
				print("Esprit : +", heal_amount, " HP soignés")
		heal_timer = heal_cooldown

func  bihavior_diurnal(_delta):
	var is_daytime = current_hour >= day_start_hour and current_hour < day_end_hour
	
	if not is_daytime:
		velocity=Vector3.ZERO
		return
		
	var dist = global_position.direction_to(player.global_position)
	if dist < detection_radius:
		chase_player(speed)
	else:
		var t = Time.get_ticks_msec() * 0.001
		velocity = Vector3(sin(t) * speed * 0.3, 0.0, 0.0)
		
