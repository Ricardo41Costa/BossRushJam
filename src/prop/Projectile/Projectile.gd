extends RigidBody3D
class_name Projectile

const ACTOR_GROUP : = "Actor"

@export var DAMAGE = 50
@export var MAX_SPEED = 10

var shoot = false

func _ready() -> void:
	set_as_top_level(true)
