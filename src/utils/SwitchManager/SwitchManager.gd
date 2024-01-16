extends Node

var left_prop : Prop = null
var right_prop : Prop = null

@onready var timer = $SwapTimer

func _on_timeout():
	var player = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	player.disable_collision(true)

func _input(event):
	if event.is_action_pressed("player_swap"):
		if left_prop != null and right_prop != null:
			var left_pos = left_prop.global_position
			var right_pos = right_prop.global_position
			
			left_prop.global_position = right_pos
			right_prop.global_position = left_pos
			
			left_prop = null
			right_prop = null
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
			
			left_prop = null
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
			
			right_prop = null
			return

func set_left_prop(prop : Prop):
	left_prop = prop

func set_right_prop(prop : Prop):
	right_prop = prop
