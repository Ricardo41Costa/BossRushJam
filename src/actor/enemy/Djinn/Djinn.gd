extends Enemy
class_name Djinn

@onready var lamp1 = $Lamps/Lamp1
@onready var lamp2 = $Lamps/Lamp2
@onready var lamp3 = $Lamps/Lamp3
@onready var lamp4 = $Lamps/Lamp4

func _ready():
	add_to_group(Constants.ACTOR_GROUP)
	add_to_group(Constants.ENEMY_GROUP)
	state = Constants.ATTACK
	GameManager.set_health_boss_value(HEALTH)

func _process(delta):
	GameManager.set_health_boss_visibility(true if HEALTH > 0 else false)

func _physics_process(_delta):
	match state:
		Constants.STUN:
			update_barrier(false)
		Constants.ATTACK:
			update_barrier(true)
		Constants.HURT:
			state = Constants.ATTACK
		Constants.DEATH:
			pass

func _on_attack_timeout():
	state = Constants.STUN

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
			lamp4.visible = true

func set_damage(attacker, damage):
	if state != Constants.HURT and state != Constants.DEATH:
		var audio = $HurtAudio
		audio.play()
		
		HEALTH -= damage
		
		GameManager.set_health_boss_value(HEALTH)
		update_lamp()
		
		if HEALTH <= 0:
			state = Constants.DEATH
			return
		
		state = Constants.HURT

func die() -> void:
	queue_free()
