class_name Pause
extends Control

func _on_resume_pressed():
	set_up_screen(false)

func _on_checkpoint_pressed():
	set_up_screen(false)
	#SceneManager.change_scene(get_tree().get_current_scene(), "res://src/scene/Prototype.tscn")

func _on_quit_pressed():
	set_up_screen(false)
	#SceneManager.change_scene(get_tree().get_current_scene(), "res://src/scene/MainScene.tscn")

func _unhandled_input(event):
	if event is InputEventMouseMotion and get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func start():
	$Panel/VBoxContainer/Resume.grab_focus()
	set_up_screen(true)

func set_up_screen(to_show):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)#Input.MOUSE_MODE_CONFINED if to_show else 
	visible = to_show
	get_tree().paused = to_show