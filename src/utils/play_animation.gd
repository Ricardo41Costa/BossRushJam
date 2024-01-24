extends Node

@export var anim_name = "Idle"

@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play(anim_name)
