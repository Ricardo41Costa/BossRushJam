class_name Dialog
extends Area3D

##see assets/json/strings.json
@export var TEXT_KEY = ""

@onready var label = $Label
@onready var anim_player = $AnimationPlayer

func _on_body_entered(body):
	if body.is_in_group(Constants.PLAYER_GROUP):
		DialogManager.prepare_text_array(TEXT_KEY)
		if anim_player.current_animation != Constants.ANIM_IDLE:
			anim_player.play(Constants.ANIM_IDLE)

func _on_body_exited(body):
	if body.is_in_group(Constants.PLAYER_GROUP):
		DialogManager.prepare_text_array(null)
		anim_player.play(Constants.ANIM_RESET)
