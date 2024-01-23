extends CharacterBody3D
class_name Prop

@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_selected = false

func _ready():
	add_to_group(Constants.PROP_GROUP)

func calculate_gravity_velocity(delta) -> Vector3:
	var out = velocity
	if !is_on_floor():
		out.y -= gravity * delta
	return out

func set_selected(selected : bool, is_left : bool = true):
	is_selected = selected
	
	if is_left:
		$LeftSelected.visible = is_selected
		$RightSelected.visible = false
	else:
		$LeftSelected.visible = false
		$RightSelected.visible = is_selected
