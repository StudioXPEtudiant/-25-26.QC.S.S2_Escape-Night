extends CharacterBody3D

@export var trigger_distance: float = 4.0
@export var flash_duration: float = 0.5

var player: Node3D
var has_triggered: bool = false

@onready var light: OmniLight3D = $OmniLight3D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	light.visible = false

func _physics_process(delta):
	if player == null or has_triggered:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance < trigger_distance:
		trigger_alarm()

func trigger_alarm():
	has_triggered = true
	print("FLASH")

	light.visible = true
	await get_tree().create_timer(flash_duration).timeout
	light.visible = false
