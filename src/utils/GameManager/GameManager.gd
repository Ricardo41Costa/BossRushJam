extends Node

@onready var health_bar_over_right = preload("res://assets/img/health_bar_over_right.png")
@onready var health_bar_over_left = preload("res://assets/img/health_bar_over_left.png")
@onready var health_bar_over_both = preload("res://assets/img/health_bar_over_both.png")
@onready var health_bar_over = preload("res://assets/img/health_bar_over.png")

@onready var timer = $SwapTimer
@onready var health_bar = $HealthBar
@onready var boss_health_bar = $BossHealthBar

var left_prop : Prop = null
var right_prop : Prop = null

var is_in_game : bool = false
var scene_index : int = 0
var scenes_paths : Array = [
	"res://src/scene/MainSceneTutorial.tscn", 
	"res://src/scene/MainSceneWarrior.tscn",
	"res://src/scene/MainSceneUnicorn.tscn",
	#"res://src/scene/MainSceneDjinn.tscn"
]

func _on_timeout():
	var player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	player.disable_collision(true)

func _input(event):
	if event.is_action_pressed("game_pause"):
		print("is_in_game ", is_in_game)
		if is_in_game:
			var pause_menu = $Pause
			pause_menu.start()
			set_health_visibility(false)
			set_health_boss_visibility(false)
	
	if event.is_action_pressed("player_swap"):
		if left_prop != null and right_prop != null:
			var left_pos = left_prop.global_position
			var right_pos = right_prop.global_position
			
			left_prop.global_position = right_pos
			right_prop.global_position = left_pos
			
			left_prop.set_selected(false)
			right_prop.set_selected(false, false)
			
			left_prop = null
			right_prop = null
			
			change_over_texture()
			return
		
		if left_prop != null:
			var player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
			
			var left_pos = left_prop.global_position
			var player_pos = player.global_position
			
			player.disable_collision(false)
			player.global_position = left_pos
			left_prop.global_position = player_pos
			
			var target_direction = left_pos.direction_to(player_pos)
			player.rotate_direction(target_direction, true)
			
			timer.start()
			
			left_prop.set_selected(false)
			left_prop = null
			
			change_over_texture()
			return
		
		if right_prop != null:
			var player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
			
			var right_pos = right_prop.global_position
			var player_pos = player.global_position
			
			player.disable_collision(false)
			player.global_position = right_pos
			right_prop.global_position = player_pos
			
			var target_direction = right_pos.direction_to(player_pos)
			player.rotate_direction(target_direction, true)
			
			timer.start()
			
			right_prop.set_selected(false, false)
			right_prop = null
			
			change_over_texture()
			return

func _on_next_scene_timeout():
	increment_scene_index()
	if scene_index < scenes_paths.size():
		SceneManager.change_scene(get_scene_path())
	else:
		scene_index = 0
		SceneManager.end_game()

func reset():
	left_prop = null
	right_prop = null
	change_over_texture()

func start_next_scene():
	var next_scene_timer = $NextSceneTimer
	next_scene_timer.start()

func increment_scene_index():
	scene_index += 1

func get_scene_path():
	return scenes_paths[scene_index]

func set_in_game(in_game):
	set_health_visibility(in_game)
	is_in_game = in_game

func set_health_value(health):
	health_bar.value = health

func set_health_boss_value(health):
	boss_health_bar.value = health

func set_health_visibility(visible):
	health_bar.visible = visible

func set_health_boss_visibility(visible):
	boss_health_bar.visible = visible

func change_over_texture():
	if left_prop != null and right_prop != null:
		health_bar.texture_over = health_bar_over
		return
	
	if left_prop != null:
		health_bar.texture_over = health_bar_over_right
		return
	
	if right_prop != null:
		health_bar.texture_over = health_bar_over_left
		return
	
	health_bar.texture_over = health_bar_over_both

func set_left_prop(prop : Prop):
	if right_prop != null and right_prop == prop:
		right_prop.set_selected(false, false)
		right_prop = null
	
	if left_prop != null:
		left_prop.set_selected(false)
	
	left_prop = prop
	left_prop.set_selected(true)
	change_over_texture()

func set_right_prop(prop : Prop):
	if left_prop != null and left_prop == prop:
		left_prop.set_selected(false)
		left_prop = null
	
	if right_prop != null:
		right_prop.set_selected(false, false)
	
	right_prop = prop
	right_prop.set_selected(true, false)
	change_over_texture()
