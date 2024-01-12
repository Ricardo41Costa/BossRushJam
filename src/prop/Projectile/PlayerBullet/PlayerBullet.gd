extends Projectile
class_name PlayerBullet

@export var LIFESPAN : = 4

var time = 0

func _physics_process(delta: float) -> void:
	set_timer(delta)
	
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z.normalized() * MAX_SPEED)

func _on_body_entered(body: Node) -> void:
	if body.has_method("set_damage"):
		body.set_damage(DAMAGE)
	queue_free()

func set_timer(delta: float) -> void:
	time += delta
	if time >= LIFESPAN:
		queue_free()
