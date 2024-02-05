class_name InteractArea
extends Area3D

@onready var label = $Label
@onready var anim_player = $AnimationPlayer

func _on_body_entered(body):
	if body.is_in_group(Constants.PLAYER_GROUP):
		GameManager._on_next_scene_timeout()

