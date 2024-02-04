extends Prop
class_name ExplosivePot

@onready var particles = $GPUParticles3D

var is_active = false
var is_falling = false

func _physics_process(delta):
	if velocity.y != 0:
		is_falling = true
	
	if is_falling and is_on_floor():
		do_action()
	
	velocity = calculate_gravity_velocity(delta)
	move_and_slide()

func _on_finished():
	queue_free()

func do_action():
	if not is_active:
		is_active = true
		start_blast()

func start_blast():
	var mesh = $body
	var audio = $ExplosionPlayer
	mesh.visible = false
	particles.emitting = true
	audio.play()
	
	var area = get_node("BlastRadius")
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		var space = get_world_3d().direct_space_state
		var parameters = PhysicsRayQueryParameters3D.create(global_transform.origin, body.global_transform.origin)
		var collision = space.intersect_ray(parameters)
		if not collision.is_empty() and collision.collider.is_in_group(Constants.ACTOR_GROUP):
			body.set_damage(self, 1)
