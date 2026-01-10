extends Camera3D

var angle_cam = rotation_degrees.y
# Called when the node enters the scene tree for the first time.




func _process(delta: float) -> void:
	if Input.is_action_pressed("mouvement Droite cam"):
		angle_cam + PI / 4
	
	
	if Input.is_action_pressed("mouvement gauche cam"):
		angle_cam + PI / 4
	



func _input(event):
	
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotation horizontale (autour de Y)
		rotation.y -= event.relative.x * sens_souris
		
		# Rotation verticale (autour de X)
		rotation.x -= event.relative.y * sens_souris
		
		# Limiter la rotation verticale pour éviter les retournements (ex: entre -80 et 80 degrés)
		rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(80))

@export var sens_souris: float = 0.002 # Ajustez ce facteur

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Capture le curseur
	pass




func _unhandled_input(event):
	# Relâcher le curseur avec la touche Échap
	if event.is_action_pressed("Cancel"): # "ui_cancel" est souvent la touche Échap
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Rere-capturer si on clique à nouveau (vous pourriez ajouter une logique)
	if event is InputEventMouseMotion:
		var mouse_delta = event.relative
		rotate_y(-event.relative.x * 0.1)
		#rotate_x(-event.relative.y * 0.1)
	
