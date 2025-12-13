extends CharacterBody3D 


var SPEED = 5.0
const JUMP_VELOCITY = 4.5


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
	
	
	var input_dir := Input.get_vector("Gauche", "Droite", "Avance", "Recule")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func _input(event):
	var mouse_delta = event.relative
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.1)
		rotate_x(-event.relative.y * 0.1)
