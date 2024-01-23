extends RigidBody3D
class_name Pickup

@onready var anim_player = $AnimationPlayer

@export var RANGE : = 10

func _ready():
	add_to_group(Constants.PROP_GROUP)
	anim_player.play(Constants.ANIM_IDLE)
	apply_impulse(transform.basis.y, transform.basis.y * RANGE)
	apply_impulse(transform.basis.z, transform.basis.z * randf_range(RANGE, -RANGE))
	apply_impulse(transform.basis.x, transform.basis.x * randf_range(RANGE, -RANGE))

func _on_body_entered(body):
	if body.is_in_group(Constants.PLAYER_GROUP):
		body.heal(1)
		queue_free()

func _on_despawn_timeout():
	queue_free()
