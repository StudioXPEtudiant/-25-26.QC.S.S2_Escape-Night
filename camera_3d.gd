extends Camera3D

var angle_cam = rotation_degrees.y
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 



func _process(delta: float) -> void:
	if Input.is_action_pressed("mouvement Droite cam"):
		angle_cam + PI / 4
	
	
	if Input.is_action_pressed("mouvement gauche cam"):
		angle_cam + PI / 4
	

func _unhandled_input(delta):
	pass

func _input(event):
	
	if event is InputEventMouseMotion:
		var mouse_delta = event.relative
		rotate_y(-event.relative.x * 0.1)
		#rotate_x(-event.relative.y * 0.1)
	
