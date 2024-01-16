extends Area3D
class_name Projectile

@export var DAMAGE = 50
@export var MAX_SPEED = 10

func _ready() -> void:
	set_as_top_level(true)
