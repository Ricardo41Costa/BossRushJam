extends Node3D

func _ready():
	var anim_player = $AnimationPlayer
	anim_player.play("start")
	GameManager.set_in_game(false)
