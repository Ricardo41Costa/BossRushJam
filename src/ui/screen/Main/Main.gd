class_name MainMenu
extends Control

func _ready():
	#Utils.reset_checkpoint()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	$Panel/VBoxContainer/Start.grab_focus()

func _on_start_pressed():
	pass
	#SceneManager.change_scene(self, "res://src/scene/Prototype.tscn")

func _on_credits_pressed():
	pass
	#SceneManager.change_scene(self, "res://src/gui/Screen/Credits/credits.tscn")

func _on_quit_pressed():
	get_tree().quit()
