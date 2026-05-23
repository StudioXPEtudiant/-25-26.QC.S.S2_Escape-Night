extends CharacterBody3D 

@onready var collision_shape = $CollisionShape3D
@onready var camera = $Camera3D
@onready var crouch_cast = $ShapeCast3D # Un ShapeCast3D pointant vers le haut

var Impultion = 40.0
var SPEED = 5.0
var is_crouching = false
var stand_height = 2.0
var crouch_height = 1.0
var camera_stand_pos = 1.5
var camera_crouch_pos = 0.5

const JUMP_VELOCITY = 4.5



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("Saut") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("Sprint"):
		SPEED = 15.0
	else:
		SPEED = 5.0
	if Input.is_action_pressed("Accroupir"):
		crouch()
	else:
		stand()
	#	if !crouch_cast.is_colliding(): # Ne se relève que si l'espace est libre
	#		stand()
		pass
	var input_dir = Input.get_vector("Gauche", "Droite", "Recule", "Avance")
	var foward = -camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	foward.y = 0
	right.y = 0
	foward = foward.normalized()
	right = right.normalized()
	var direction = ( foward * input_dir.y + right * input_dir.x).normalized()
	if direction:#Flèche directionnel
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_pressed("Sprint") and Input.is_action_pressed("Accroupir"):#shift et "c"
		velocity.x = direction.x*Impultion
		velocity.z = direction.z*Impultion
		#await get_tree().create_timer(2.0).timeout#durée de l'effet
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	else:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	
	move_and_slide()

#func _input(event):
	#var sens_souris: float = 1e-511
	#if event is InputEventMouseMotion:
		#var mouse_delta = event.relative
		#rotate_y(-event.relative.x * 0.1)


func crouch():
	if  not is_crouching:
		is_crouching = true# Réduire la hauteur de la collision et la caméra
		collision_shape.shape.size.y = crouch_height
		collision_shape.position.y = crouch_height / 2
		camera.position.y = camera_crouch_pos

func stand():
	if  is_crouching:
		is_crouching = false# Rétablir la hauteur
		collision_shape.shape.size.y = stand_height
		collision_shape.position.y = stand_height / 2
		camera.position.y = camera_stand_pos

signal munitions_changed(nouvelle_valeur)
var munitions = 10

func tirer():
	#if Input.is_action_just_pressed("Attaque"):
	munitions -= 1
	munitions_changed.emit(munitions) # Émet le signal
