class_name DialogBox
extends PanelContainer

##number of char 130-140
#@export var 

@onready var label = $MarginContainer/TextBox

func _ready():
	set_dialog_visibility(false)

func set_dialog_visibility(isVisible):
	visible = isVisible

func set_dialog_text(text):
	label.clear()
	label.append_text(text)
