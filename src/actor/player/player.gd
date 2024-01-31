class_name Player
extends Actor

@onready var spring_arm = $SpringArm3D

@onready var left_bullet = preload("res://src/prop/Projectile/PlayerBullet/PlayerBulletLeft.tscn")
@onready var right_bullet = preload("res://src/prop/Projectile/PlayerBullet/PlayerBulletRight.tscn")

var can_shoot = true

var direction = Vector3.ZERO

func _ready():
	add_to_group(Constants.ACTOR_GROUP)
	add_to_group(Constants.PLAYER_GROUP)

func _physics_process(delta):
	direction = get_direction()
	match state:
		Constants.IDLE:
			check_state()
			animate_player()
			
			velocity = calculate_idle_velocity(direction)
		Constants.ROAM:
			check_state()
			animate_player()
			
			velocity = calculate_move_velocity(direction, SPEED)
		Constants.ATTACK:
			velocity = calculate_idle_velocity()
		Constants.HURT:
			if anim_player.get_current_animation() != Constants.ANIM_HURT:
				anim_player.play(Constants.ANIM_HURT)
				await anim_player.animation_finished
				check_state()
			
			var target_direction = global_position.direction_to(target_pos)
			rotate_direction(target_direction)
			
			calculate_knockback_velocity(target_direction, 2.5)
		Constants.DEATH:
			if anim_player.get_assigned_animation() != Constants.ANIM_DEATH:
				anim_player.play(Constants.ANIM_DEATH)
			
			if not SceneManager.is_changing:
				SceneManager.game_over(get_tree().get_current_scene(), "res://src/scene/Prototype.tscn")
				GameManager.set_health_visibility(false)
			
			velocity = calculate_idle_velocity()
	
	velocity = calculate_gravity_velocity(delta)
	
	move_and_slide()

func _process(delta):
	if not state == Constants.DEATH:
		spring_arm.global_transform.origin = global_transform.origin

func _input(event):
	if HEALTH <= 0 or state == Constants.HURT:
		return
	
	if event.is_action_pressed("game_pause") and not SceneManager.is_changing:
		pass
	
	if event.is_action_pressed("player_shoot") and can_shoot:
		state = Constants.ATTACK
		can_shoot = false
		
		var camera3d = $SpringArm3D/Camera
		var to = camera3d.project_ray_normal(event.position)
		
		rotate_direction(to)
		
		shoot(false)
	
	if event.is_action_pressed("player_shoot_alt") and can_shoot:
		state = Constants.ATTACK
		can_shoot = false
		
		var camera3d = $SpringArm3D/Camera
		var to = camera3d.project_ray_normal(event.position)
		
		rotate_direction(to)
		
		shoot(true)

func shoot(right : bool):
	var bullet
	
	anim_player.play("Shoot")
	await anim_player.animation_finished
	
	if right:
		bullet = right_bullet.instantiate()
	else:
		bullet = left_bullet.instantiate()
	
	add_child(bullet)
	bullet.transform = global_transform
	
	anim_player.play("Shoot", -1, -2.0, true)
	await anim_player.animation_finished
	can_shoot = true
	
	check_state()

func disable_collision(disable):
	set_collision_mask_value(4, disable)

func rotate_direction(direction : Vector3, camera : bool = false):
	var look_direction = Vector2(direction.z, direction.x)
	rotation.y = look_direction.angle()
	
	if camera:
		spring_arm.reset_camera()

func check_state():
	if direction.length() > 0:
		state = Constants.ROAM
	else:
		state = Constants.IDLE

func animate_player():
	if velocity.x != 0 or velocity.z != 0:
		rotate_direction(velocity)
		
		if animate_player_y():
			return
		
		animate_movement()
		return
	
	if animate_player_y():
		return
	
	animate_idle()

func animate_idle():
	if anim_player.get_current_animation() != Constants.ANIM_IDLE:
		anim_player.play(Constants.ANIM_IDLE)

func animate_movement():
	if anim_player.get_current_animation() != Constants.ANIM_WALK:
		anim_player.play(Constants.ANIM_WALK)

func animate_player_y():
	if velocity.y > 0:
		if anim_player.get_assigned_animation() != Constants.ANIM_JUMP:
			anim_player.play(Constants.ANIM_JUMP)
		return true
	
	if velocity.y < 0:
		if anim_player.get_current_animation() != Constants.ANIM_FALL:
			anim_player.play(Constants.ANIM_FALL)
		return true
	return false

func get_direction() -> Vector3:
	var out = Vector3(
		Input.get_action_strength("player_right") - Input.get_action_strength("player_left"), 
		1.0 if Input.is_action_just_pressed("player_jump") and is_on_floor() else 0.0, 
		Input.get_action_strength("player_backward") - Input.get_action_strength("player_foward"))
	out = out.rotated(Vector3.UP, spring_arm.rotation.y)
	return out

func set_damage(attacker, damage):
	if state != Constants.HURT or state != Constants.DEATH:
		state = Constants.HURT

		target_pos = attacker.global_position

		HEALTH -= damage

		GameManager.set_health_value(HEALTH)

		if HEALTH <= 0:
			state = Constants.DEATH
			return

func kill():
	HEALTH = 0
	state = Constants.DEATH

func heal(value):
	HEALTH += value
	if HEALTH > 3:
		HEALTH = 3
	
	GameManager.set_health_value(HEALTH)
