extends CanvasLayer

@onready var anim_sprite = $Background/Loading/AnimatedSprite2D
@onready var anim_player = $AnimationPlayer

var thread: Thread
var mutex: Mutex
var loaded_scene: Resource

var is_changing = false

func _ready():
	mutex = Mutex.new()
	thread = Thread.new()

func _exit_tree():
	thread.wait_to_finish()

func reset_game():
	change_scene(loaded_scene.resource_path)

func end_game():
	is_changing = true
	anim_player.play("EndGame")
	await anim_player.animation_finished
	
	change_scene("res://src/scene/MainScreen/MainScene.tscn", "Loading2")

func game_over(next_scene):
	is_changing = true
	anim_player.play("GameOver")
	await anim_player.animation_finished
	
	change_scene(next_scene, "Loading2")

func change_scene(next_scene, loading_animation : String = "Loading"):
	AudioManager.end_background()
	GameManager.set_in_game(false)
	GameManager.reset()
	is_changing = true
	anim_sprite.play(Constants.ANIM_DEFAULT)
	anim_player.play(loading_animation)
	await anim_player.animation_finished
	
	var scene = get_tree().get_first_node_in_group(Constants.SCENE_GROUP)
	scene.queue_free()
	
	thread.start(replace_scene.bind(next_scene))

func on_thread_done():
	var next_scene_instance = loaded_scene.instantiate()
	get_tree().get_root().call_deferred("add_child", next_scene_instance)
	
	thread.wait_to_finish()
	stop_loading()

func stop_loading():
	is_changing = false
	anim_player.play_backwards("Loading")
	await anim_player.animation_finished
	anim_player.play("RESET")
	anim_sprite.stop()

func replace_scene(next_scene):
	var loader_next_scene = ResourceLoader.load_threaded_request(next_scene)
	
	if loader_next_scene == null:
		print("ERROR: IMPOSSIVEL TO LOAD SCENE")
		return
	
	while true:
		var load_status = ResourceLoader.load_threaded_get_status(next_scene)
		
		match load_status:
			0: #INVALID RESOURCE
				print("ERROR: INVALID RESOURCE")
				return
			1: #LOAD IN PROGRESS
				pass
			2: #LOAD FAILED
				print("ERROR: LOAD FAILED")
				return
			3: #LOAD DONE
				var next_scene_loader = ResourceLoader.load_threaded_get(next_scene)
				
				mutex.lock()
				loaded_scene = next_scene_loader
				mutex.unlock()
				
				call_deferred("on_thread_done")
				return
