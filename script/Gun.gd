extends Node3D

@export var domage: int = 10.0
@export var range: float = 100.0

@onready var camera: Camera3D = get_viewport().get_camera_3d()

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
		
func shoot():
	if camera == null:
		return
	
	var from = camera.global_position
	var to = from + (-camera.global_transform.basis.z * range)
	
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	
	var result = space.intersect_ray(query)
	
	if result:
		print("Touché :", result.collider)
	
	if result.collider.has_method("take_domage"):
		result.collider.take_domage(domage)
