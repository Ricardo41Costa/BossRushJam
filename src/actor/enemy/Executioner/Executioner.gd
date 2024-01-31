extends Enemy
class_name Executioner

@onready var attack_area = $body/Armature/Skeleton3D/scimitar/scimitar/AttackArea
@onready var attack_type = randi_range(0, 1) % 2 == 0

func _ready():
	add_to_group(Constants.ACTOR_GROUP)
	add_to_group(Constants.ENEMY_GROUP)
	state = Constants.ROAM
	GameManager.set_health_value(HEALTH)
	GameManager.set_health_boss_visibility(true)

func _process(delta):
	if global_position.y < 0:
		global_position.y = 0.830

func _physics_process(_delta):
	match state:
		Constants.IDLE:
			if anim_player.get_current_animation() != Constants.ANIM_IDLE:
				anim_player.play(Constants.ANIM_IDLE)
			
			velocity = calculate_idle_velocity()
		Constants.ROAM:
			if anim_player.get_current_animation() != Constants.ANIM_WALK:
				anim_player.play(Constants.ANIM_WALK)
			
			if global_position.distance_to(player.global_position) < 1:
				attack_type = randi_range(0, 1) % 2 == 0
				state = Constants.ATTACK
			
			calculate_follow_velocity(player.global_position)
		Constants.ATTACK:
			if attack_type:
				if not is_attack:
					is_attack = true
					
					anim_player.play(Constants.ANIM_ATTACK_1)
					await anim_player.animation_finished
					anim_player.play(Constants.ANIM_ATTACK_RETURN_1)
					await anim_player.animation_finished
					
					if state != Constants.HURT and state != Constants.DEATH:
						state = Constants.ROAM
					
					is_attack = false
			else:
				if not is_attack:
					is_attack = true
					
					anim_player.play(Constants.ANIM_ATTACK_3)
					await anim_player.animation_finished
					anim_player.play(Constants.ANIM_ATTACK_RETURN_3)
					await anim_player.animation_finished
					
					if state != Constants.HURT and state != Constants.DEATH:
						state = Constants.ROAM
					
					is_attack = false
			
			velocity = calculate_idle_velocity()
		Constants.HURT:
			if anim_player.get_current_animation() != Constants.ANIM_HURT:
				anim_player.play(Constants.ANIM_HURT)
				await anim_player.animation_finished
				state = Constants.ROAM
			
			var direction = global_position.direction_to(target_pos)
			var look_direction = Vector2(direction.z, direction.x)
			rotation.y = look_direction.angle()
			
			calculate_knockback_velocity(direction, 2.5)
		Constants.DEATH:
			if anim_player.assigned_animation != Constants.ANIM_DEATH:
				anim_player.play(Constants.ANIM_DEATH)
				await anim_player.animation_finished
				
				GameManager.set_health_boss_visibility(false)
			
			var direction = global_transform.origin.direction_to(target_pos)
			var look_direction = Vector2(direction.z, direction.x)
			rotation.y = look_direction.angle()
			
			velocity = calculate_idle_velocity()
	
	move_and_slide()

func _on_scimitar_entered(body):
	if is_attack:
		if body.is_in_group(Constants.PLAYER_GROUP):
			body.set_damage(self, DAMAGE)
			return
		
		if body.is_in_group(Constants.PROP_GROUP):
			if body.has_method("do_action"):
				body.do_action()
				return

func set_damage(attacker, damage):
	if state != Constants.HURT and state != Constants.DEATH:
		state = Constants.HURT
		
		target_pos = attacker.global_position
		
		HEALTH -= damage
		
		GameManager.set_health_boss_value(HEALTH)
		
		if HEALTH <= 0:
			state = Constants.DEATH
			return

func die() -> void:
	queue_free()
