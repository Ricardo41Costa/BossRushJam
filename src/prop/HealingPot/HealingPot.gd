extends Prop
class_name HealingPot

@onready var particles = $GPUParticles3D
@onready var health_pickup = preload("res://src/prop/Pickup/Health/health.tscn")

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
	var player = $BreakingPlayer
	mesh.visible = false
	particles.emitting = true
	player.play()
	
	var health = health_pickup.instantiate()
	health.transform.origin = global_transform.origin
	get_parent().add_child(health)
