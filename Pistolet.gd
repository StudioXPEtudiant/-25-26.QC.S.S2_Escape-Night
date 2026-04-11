extends Node3D
@export var amo = 10

@onready var Gun = $Node3D

func _physics_process(delta: float) -> void:
	if Gun.is_visible(true) and Input.is_action_just_pressed("Attaque"):# click gauche
		amo = amo - 1
	
	
	if Gun.is_visible and Input.is_action_just_pressed("Reload"):# r
		amo = 10
