extends Projectile
class_name EnergyBall

@export_enum("Player", "No_target") var target_type: int

@onready var target_pos = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP).global_position

func _ready():
	if target_type == 0:
		look_at(target_pos, Vector3.UP, true)

func _physics_process(delta):
	if target_type == 0:
		if global_position.distance_to(target_pos) < 0.5:
			queue_free()
	
	global_position += transform.basis.z * MAX_SPEED * delta

func _on_body_entered(body):
	if body.is_in_group(Constants.PLAYER_GROUP):
		body.set_damage(self, DAMAGE)
	queue_free()

func _on_timeout():
	queue_free()
