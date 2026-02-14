extends CharacterBody3D 

var SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera = $Camera3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("Saut") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("Sprint"):
		SPEED = 10.0
	else:
		SPEED = 5.0
	
	var input_dir = Input.get_vector("Gauche", "Droite", "Recule", "Avance")
	var foward = -camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	foward.y = 0
	right.y = 0
	foward = foward.normalized()
	right = right.normalized()
	var direction = ( foward * input_dir.y + right * input_dir.x).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _input(event):
	var sens_souris: float = 0.002
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotation horizontale (autour de Y)
		rotation.y -= event.relative.x * sens_souris
		
		# Rotation verticale (autour de X)
		rotation.x -= event.relative.y * sens_souris
		
		# Limiter la rotation verticale pour éviter les retournements (ex: entre -80 et 80 degrés)
		rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(80))
