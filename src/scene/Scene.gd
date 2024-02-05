extends Node

func _ready():
	GameManager.set_in_game(true)
	AudioManager.start_background()
