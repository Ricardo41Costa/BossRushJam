extends Projectile
class_name PlayerBullet

@export var is_left : bool = true

func _physics_process(delta: float) -> void:
	global_position += transform.basis.z * MAX_SPEED * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Constants.PROP_GROUP):
		if is_left:
			GameManager.set_left_prop(body)
		else:
			GameManager.set_right_prop(body)
	queue_free()

func _on_timeout():
	queue_free()
