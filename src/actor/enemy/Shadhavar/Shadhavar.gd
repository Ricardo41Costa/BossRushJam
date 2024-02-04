extends Enemy
class_name Shadhavar

@onready var state_timer = $StateTimer
@onready var spotted_area = $SpottedArea

var direction = Vector3.FORWARD

func _ready():
	add_to_group(Constants.ACTOR_GROUP)
	add_to_group(Constants.ENEMY_GROUP)
	state = Constants.ROAM
	GameManager.set_health_boss_value(HEALTH)

func _process(_delta):
	GameManager.set_health_boss_visibility(true if HEALTH > 0 else false)
	
	if global_position.y < 0.659:
		global_position.y = 0.659

func _physics_process(_delta):
	match state:
		Constants.IDLE:
			if anim_player.get_current_animation() != Constants.ANIM_IDLE:
				anim_player.play(Constants.ANIM_IDLE)
			
			velocity = calculate_idle_velocity()
		Constants.ROAM:
			if anim_player.get_current_animation() != Constants.ANIM_WALK:
				anim_player.play(Constants.ANIM_WALK)
			
			check_if_spotted()
			
			calculate_follow_velocity(player.global_position)
		Constants.AGRO:
			if anim_player.get_current_animation() != "BuildUp":
				anim_player.play("BuildUp")
			
			if state_timer.is_stopped():
				state_timer.set_wait_time(3)
				state_timer.start()
			
			var local_direction = global_position.direction_to(player.global_position)
			var look_direction = Vector2(local_direction.z, local_direction.x)
			rotation.y = look_direction.angle()
			
			velocity = calculate_idle_velocity()
		Constants.ATTACK:
			if anim_player.get_current_animation() != "Charge":
				anim_player.play("Charge")
			
			var look_direction = Vector2(direction.z, direction.x)
			rotation.y = look_direction.angle()
			
			if is_on_wall():
				is_attack = false
				state = Constants.HURT
			
			velocity = calculate_move_velocity(direction, SPEED * 2)
		Constants.HURT:
			if anim_player.get_current_animation() != Constants.ANIM_HURT:
				anim_player.play(Constants.ANIM_HURT)
				await anim_player.animation_finished
				state = Constants.ROAM
			
			var look_direction = Vector2(direction.z, direction.x)
			rotation.y = look_direction.angle()
			
			calculate_knockback_velocity(direction, 1)
		Constants.DEATH:
			if anim_player.assigned_animation != Constants.ANIM_DEATH:
				anim_player.play(Constants.ANIM_DEATH)
				await anim_player.animation_finished
				GameManager.start_next_scene()
			
			var local_direction = global_transform.origin.direction_to(target_pos)
			var look_direction = Vector2(local_direction.z, local_direction.x)
			rotation.y = look_direction.angle()
			
			calculate_idle_velocity(local_direction)
	
	move_and_slide()

func _on_attack_area_entered(body):
	if is_attack:
		if body.is_in_group(Constants.PLAYER_GROUP):
			body.set_damage(self, DAMAGE)
			return
		
		if body.is_in_group(Constants.PROP_GROUP):
			if body.has_method("do_action"):
				body.do_action()
			return

func _on_state_timeout():
	if state == Constants.AGRO:
		direction = global_position.direction_to(player.global_position)
		state = Constants.ATTACK
		is_attack = true
		return
	
	if state == Constants.ATTACK:
		state = Constants.ROAM
		is_attack = false
		return

func check_if_spotted():
	var bodies = spotted_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group(Constants.PLAYER_GROUP):
			state = Constants.AGRO

func set_damage(attacker, damage):
	if state != Constants.HURT and state != Constants.DEATH:
		is_attack = false
		state = Constants.HURT
		
		var audio = $HurtAudio
		audio.play()
		
		target_pos = attacker.global_position
		
		HEALTH -= damage
		
		GameManager.set_health_boss_value(HEALTH)
		
		if HEALTH <= 0:
			state = Constants.DEATH
			return

func die() -> void:
	queue_free()
