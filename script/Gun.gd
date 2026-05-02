extends Node3D

@export var damage: int = 10
@export var shoot_range: float = 100.0
@export var fire_rate: float = 0.2        
@export var hit_effect: GPUParticles3D    
var camera: Camera3D
var can_shoot: bool = true

func _ready():
	camera = get_viewport().get_camera_3d()

func _input(event):
	if event.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	if camera == null:
		camera = get_viewport().get_camera_3d()
	if camera == null:
		push_warning("Gun : aucune caméra trouvée")
		return

	can_shoot = false

	var from = camera.global_position
	var to = from + (-camera.global_transform.basis.z * shoot_range)

	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]

	var result = space.intersect_ray(query)

	if result:
		var collider = result.collider
		var point = result.position
		var normal = result.normal

		print("Touché : ", collider.name, " à ", point)

		spawn_hit_effect(point, normal)

		# Applique les dégâts si la méthode existe
		if collider.has_method("take_damage"):
			collider.take_damage(damage)

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func spawn_hit_effect(point: Vector3, normal: Vector3):
	if hit_effect == null:
		return
	var fx = hit_effect.duplicate()
	get_tree().root.add_child(fx)
	fx.global_position = point
	fx.look_at(point + normal, Vector3.UP)
	fx.emitting = true
	await get_tree().create_timer(2.0).timeout
	fx.queue_free()
