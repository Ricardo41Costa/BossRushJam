class_name Player
extends Actor

@onready var spring_arm = $SpringArm3D
@onready var death_rect = $SpringArm3D/Camera/CanvasLayer/Main/DeathCont
@onready var pause_menu = $SpringArm3D/Camera/CanvasLayer/Pause

var direction = Vector3.ZERO

func _ready():
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
			if velocity.y != 0:
				if anim_player.get_assigned_animation() != Constants.ANIM_ATTACK_3 and anim_player.get_current_animation() != Constants.ANIM_ATTACK_1:
					anim_player.play(Constants.ANIM_ATTACK_3)
					await anim_player.animation_finished
					
					check_state()
			else:
				if anim_player.get_current_animation() != Constants.ANIM_ATTACK_3 and anim_player.get_current_animation() != Constants.ANIM_ATTACK_RETURN_3:
					if anim_player.get_current_animation() != Constants.ANIM_ATTACK_1 and anim_player.get_current_animation() != Constants.ANIM_ATTACK_RETURN_1:
						anim_player.play(Constants.ANIM_ATTACK_1)
						await anim_player.animation_finished
						
						anim_player.play(Constants.ANIM_ATTACK_RETURN_1)
						await anim_player.animation_finished
						
						check_state()
			
			velocity = calculate_idle_velocity()
		Constants.HURT:
			if anim_player.get_current_animation() != Constants.ANIM_HURT:
				anim_player.play(Constants.ANIM_HURT)
				await anim_player.animation_finished
				state = Constants.IDLE
			
			var target_direction = global_transform.origin.direction_to(target_pos)
			var look_direction = Vector2(target_direction.z, target_direction.x)
			rotation.y = look_direction.angle()
			
			calculate_knockback_velocity(target_direction, 0.5)
		Constants.DEATH:
			if anim_player.get_assigned_animation() != Constants.ANIM_DEATH:
				anim_player.play(Constants.ANIM_DEATH)
			
			if not SceneManager.is_changing:
				SceneManager.game_over(get_tree().get_current_scene(), "res://src/scene/Prototype.tscn")
				$SpringArm3D/Camera/CanvasLayer/Main.hide()
			
			velocity = calculate_idle_velocity()
	
	velocity = calculate_gravity_velocity(delta)
	
	move_and_slide()

func _process(_delta):
	if not state == Constants.DEATH:
		spring_arm.global_transform.origin = global_transform.origin

func _input(event):
	if HEALTH <= 0 or state == Constants.HURT:
		return
	
	if event.is_action_pressed("game_pause") and not SceneManager.is_changing:
		pause_menu.start()
	
	if event.is_action_pressed("player_attack"):
		state = Constants.ATTACK

func _on_attack_body_entered(body):
	if state == Constants.ATTACK:
		if body.is_in_group(Constants.ENEMY_GROUP):
			body.set_damage(self, DAMAGE)

func check_state():
	if direction.length() > 0:
		state = Constants.ROAM
	else:
		state = Constants.IDLE

func animate_player():
	if velocity.x != 0 or velocity.z != 0:
		var look_direction = Vector2(velocity.z, velocity.x)
		rotation.y = look_direction.angle()
		
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
	target_pos = attacker.get_actor_position()
	
	HEALTH -= damage
	
	#get_tree().call_group(Utils.HEALTH_UI_GROUP, "update_value", HEALTH)
	
	if HEALTH <= 0:
		state = Constants.DEATH
		return
	
	state = Constants.HURT

func kill(type):
	HEALTH = 0
	state = Constants.DEATH

func heal(value):
	var health_ui = get_tree().get_first_node_in_group(Constants.HEALTH_UI_GROUP)
	
	HEALTH += value
	if HEALTH > health_ui.get_max_health():
		HEALTH = health_ui.get_max_health()
	
	health_ui.update_value(HEALTH)
