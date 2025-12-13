extends Camera3D

var angle_cam = Vector2.RIGHT.angle()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 



func _process(delta: float) -> void:
	if Input.is_action_pressed("mouvement Droite cam"):
		angle_cam + PI / 4
		pass
	
