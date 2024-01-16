class_name Actor
extends CharacterBody3D

@export var HEALTH : float = 20
@export var SPEED : float = 50
@export var JUMP_FORCE : float = 10
@export var DAMAGE = 2

@onready var state = Constants.IDLE
@onready var anim_player = $body/AnimationPlayer

@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var target_pos = null

func _ready():
	add_to_group(Constants.ACTOR_GROUP)

func die() -> void:
	queue_free()

func set_damage(attacker, damage):
	target_pos = attacker.get_actor_position()
	
	HEALTH -= damage
	
	if HEALTH <= 0:
		die()

func calculate_gravity_velocity(delta) -> Vector3:
	var out = velocity
	if !is_on_floor():
		out.y -= gravity * delta
	return out

func calculate_move_velocity(
				direction : Vector3,
				speed : float = SPEED) -> Vector3:
	
	var out : = velocity
	out.x = speed * direction.x
	out.z = speed * direction.z
	
	if direction.y == 1.0:
		out.y = JUMP_FORCE
	
	return out

func calculate_idle_velocity(direction : Vector3 = Vector3.ZERO) -> Vector3:
	var out : = velocity
	out.x = Vector3.ZERO.x
	out.z = Vector3.ZERO.z
	
	if direction.y == 1.0:
		out.y = JUMP_FORCE
	
	return out

func calculate_knockback_velocity(direction, force):
	direction *= -1
	velocity = calculate_move_velocity(direction, force)

#func get_actor_position() -> Vector3:
#	return global_position
