extends Enemy
class_name Djinn

@onready var lamp1 = $Lamps/Lamp1
@onready var lamp2 = $Lamps/Lamp2
@onready var lamp3 = $Lamps/Lamp3
@onready var lamp4 = $Lamps/Lamp4
@onready var body = $body
@onready var attack_position = $AttackPosition

@onready var attack_timer = $AttackTimer
@onready var cooldown_timer = $CooldownTimer
@onready var stun_timer = $StunTimer
@onready var animation_timer = $AnimationTimer

@onready var energy_ball = preload("res://src/prop/Projectile/EnergyBall/EnergyBall.tscn")

var can_attack = false
var attack_speed = 0.5
var attack_count = 3
var bullet_speed = 15

func _ready():
	add_to_group(Constants.ACTOR_GROUP)
	add_to_group(Constants.ENEMY_GROUP)
	state = Constants.ATTACK
	GameManager.set_health_boss_value(HEALTH)
	attack_timer.start()
	cooldown_timer.start()

func _process(delta):
	GameManager.set_health_boss_visibility(true if HEALTH > 0 else false)

func _physics_process(_delta):
	match state:
		Constants.STUN:
			if anim_player.assigned_animation != "InLamp":
				anim_player.play("InLamp")
				await anim_player.animation_finished
				stun_timer.start()
				update_barrier(false)
		Constants.ATTACK:
			if can_attack:
				if anim_player.get_current_animation() != Constants.ANIM_ATTACK_1:
					anim_player.play(Constants.ANIM_ATTACK_1)
					animation_timer.start()
					await animation_timer.timeout
					anim_player.pause()
					
					spawn_attack_player()
					
					anim_player.play()
					await anim_player.animation_finished
					cooldown_timer.start()
					can_attack = false
			else:
				if anim_player.get_current_animation() != Constants.ANIM_IDLE:
					anim_player.play(Constants.ANIM_IDLE)
			
			var local_direction = global_position.direction_to(player.global_position)
			var look_direction = Vector2(local_direction.z, local_direction.x)
			rotation.y = look_direction.angle()
			
			velocity = calculate_idle_velocity(local_direction)
		Constants.HURT:
			update_barrier(true)
			anim_player.play_backwards("InLamp")
			await anim_player.animation_finished
			start_attack_state()
		Constants.DEATH:
			pass

func _on_attack_timeout():
	cooldown_timer.stop()
	state = Constants.STUN

func _on_cooldown_timeout():
	can_attack = true

func _on_stun_timeout():
	anim_player.play_backwards("InLamp")
	await anim_player.animation_finished
	start_attack_state()

func spawn_attack_player():
	for i in attack_count:
		var bullet = energy_ball.instantiate()
		bullet.global_position = attack_position.global_position
		bullet.target_type = 0
		bullet.MAX_SPEED = bullet_speed
		add_child(bullet)
		
		var audio = $ShotAudio
		audio.play()
		
		await get_tree().create_timer(attack_speed).timeout

func start_attack_state():
	state = Constants.ATTACK
	cooldown_timer.start()
	attack_timer.start()

func stop_timer():
	cooldown_timer.stop()
	attack_timer.stop()
	stun_timer.stop()

func update_barrier(enabled : bool):
	var barrier = $Barrier
	var collision = $Barrier/CollisionShape3D
	barrier.visible = enabled
	collision.disabled = not enabled

func update_lamp():
	match HEALTH:
		3.0:
			lamp1.visible = true
			lamp2.visible = false
			lamp3.visible = false
			lamp4.visible = false
		2.0:
			lamp1.visible = false
			lamp2.visible = true
			lamp3.visible = false
			lamp4.visible = false
		1.0:
			lamp1.visible = false
			lamp2.visible = false
			lamp3.visible = true
			lamp4.visible = false
		0:
			lamp1.visible = false
			lamp2.visible = false
			lamp3.visible = false
			lamp4.visible = false

func set_damage(attacker, damage):
	if state != Constants.HURT and state != Constants.DEATH:
		var audio = $HurtAudio
		audio.play()
		
		HEALTH -= damage
		attack_count += 1
		attack_speed -= 0.1
		bullet_speed += 5
		
		GameManager.set_health_boss_value(HEALTH)
		update_lamp()
		
		if HEALTH <= 0:
			stop_timer()
			GameManager.start_next_scene()
			state = Constants.DEATH
			return
		
		state = Constants.HURT

func die() -> void:
	queue_free()
