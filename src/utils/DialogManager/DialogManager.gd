extends Node

const NEXT_TAG = "[color=orange]Next...[/color]"

@onready var dialog_box = $DialogBox

var dialogs_json = preload("res://assets/json/dialogs.json")
var text_array = []
var index = 0
var is_dialog_visible = false

func _physics_process(_delta):
	if text_array.size() > 0 and Input.is_action_just_pressed("player_interact"):
		is_dialog_visible = true
		
		if index < text_array.size():
			var text = text_array[index] + NEXT_TAG
			dialog_box.set_dialog_visibility(is_dialog_visible)
			dialog_box.set_dialog_text(text)
			index += 1
			return
		
		is_dialog_visible = false
		dialog_box.set_dialog_visibility(is_dialog_visible)
		index = 0

func prepare_text_array(key):
	if key == null:
		text_array = []
	else:
		text_array = dialogs_json.data[key]
