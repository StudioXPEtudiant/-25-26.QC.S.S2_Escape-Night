extends CharacterBody3D

@onready var target = get_node(". ./PathToYourTargetCharacterBody3D")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta):
	#var direction = (target.global_transform.origin - global_tranform.origin).normalized()
	

	move_and_slide()
