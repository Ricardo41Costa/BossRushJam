extends Node3D

func _ready():
	var anim_player = $AnimationPlayer
	anim_player.play("start")
	GameManager.set_in_game(false)
	GameManager.set_health_boss_visibility(false)
	AudioManager.start_background()
