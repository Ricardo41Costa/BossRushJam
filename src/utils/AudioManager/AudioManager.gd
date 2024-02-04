extends Node

@onready var background_music = $BackgroundMusic

func start_background():
	background_music.playing = true

func end_background():
	background_music.playing = false
