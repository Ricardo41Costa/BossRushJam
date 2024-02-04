class_name MainMenu
extends Control

func _ready():
	#Utils.reset_checkpoint()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	$Panel/VBoxContainer/Start.grab_focus()

func _on_start_pressed():
	SceneManager.change_scene(GameManager.get_scene_path())

func _on_credits_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()
