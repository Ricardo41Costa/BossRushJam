extends Actor
class_name Enemy

@export var path = []
@export var distance_margin = 1.0

@onready var state_timer = $StateTimer
@onready var spotted_area = $SpottedArea
@onready var extras = $extras
@onready var raycast = $RayCast
@onready var player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
#@onready var health_pickup = preload("res://src/prop/Pickup/Health/health.tscn")

var path_pos = 0

func _ready():
	add_to_group(Constants.ENEMY_GROUP)

func _process(_delta):
	raycast.global_transform.origin = get_actor_position()

func calculate_follow_velocity():
	var pos = path[path_pos]
	
	if pos.distance_to(global_transform.origin) > distance_margin:
		var direction = global_transform.origin.direction_to(pos)
		velocity = calculate_move_velocity(direction)
		
		if velocity.x != 0 or velocity.z != 0:
			var look_direction = Vector2(velocity.z, velocity.x)
			rotation.y = look_direction.angle()
	else:
		state = Constants.IDLE
		
		if path_pos == path.size() - 1:
			path_pos = 0
		else:
			path_pos += 1

func calculate_scared_velocity():
	var direction = global_transform.origin.direction_to(target_pos)
	direction *= -1
	
	velocity = calculate_move_velocity(direction, 5)
	
	if velocity.x != 0 or velocity.z != 0:
		var look_direction = Vector2(velocity.z, velocity.x)
		rotation.y = look_direction.angle()

func check_spotted_area(new_state):
	var bodies = spotted_area.get_overlapping_bodies()
	if bodies.size() <= 0:
		return
	
	raycast.enabled = true
	rotate_raycast()
	
	var body = raycast.get_collider()
	if body is Player and not body.is_hiding and body.state != Constants.DEATH:
		state_timer.stop()
		state = new_state
	
	raycast.enabled = false

func rotate_raycast():
	var direction = get_actor_position().direction_to(player.get_actor_position())
	var look_direction = Vector2(direction.z, direction.x)
	raycast.rotation.y = look_direction.angle()
	raycast.force_raycast_update()

#func prepare_loot():
#	var max_weight = 100
#	
#	var rng = randi() % max_weight
#	var health = health_pickup.instantiate()
#	
#	if rng <= health.WEIGHT:
#		var current_scene = get_tree().get_current_scene()
#		health.transform.origin = global_transform.origin
#		current_scene.add_child(health)
