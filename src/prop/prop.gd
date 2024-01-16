extends CharacterBody3D
class_name Prop

@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	add_to_group(Constants.PROP_GROUP)

func _physics_process(delta):
	velocity = calculate_gravity_velocity(delta)
	move_and_slide()

func calculate_gravity_velocity(delta) -> Vector3:
	var out = velocity
	if !is_on_floor():
		out.y -= gravity * delta
	return out
