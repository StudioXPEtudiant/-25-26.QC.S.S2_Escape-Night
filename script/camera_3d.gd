extends Camera3D

var angle_cam = rotation_degrees.y

#@export var sens_souris: float = 1e-2# sensibilité de la cam
func _process(delta: float) -> void:
	Input.get_last_mouse_velocity()

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_delta = event.relative
		rotate_x(-event.relative.y * 0.1)
		rotate_y(-event.relative.x * 0.1)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation.x = clamp(rotation.x, deg_to_rad(-60), deg_to_rad(60))
		#rotation.y = clamp(rotation.y, deg_to_rad(-60), deg_to_rad(60))


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Capture le curseur
	pass

func _unhandled_input(event):
	# Relâcher le curseur avec la touche Échap
	if event.is_action_pressed("Cancel"): # "ui_cancel" est souvent la touche Échap
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		#if event.is_action_pressed("Cancel"):
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Rere-capturer si on clique à nouveau (vous pourriez ajouter une logique)
	
