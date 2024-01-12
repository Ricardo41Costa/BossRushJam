extends SpringArm3D

@export var MOUSE_SENSITIVITY : float = 0.5
@export var JOYSTICK_FORCE : float = 10.0

var joystick_value_y : = 0.0
var joystick_value_x : = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta):
	if DialogManager.is_dialog_visible:
		return
	
	if get_parent().state == Constants.DEATH:
		return
	
	if joystick_value_y != 0:
		rotation_degrees.x -= JOYSTICK_FORCE * joystick_value_y
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 30)
	
	if joystick_value_x != 0:
		rotation_degrees.y -= JOYSTICK_FORCE * joystick_value_x
		rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)

func _unhandled_input(event):
	if DialogManager.is_dialog_visible:
		return
	
	if get_parent().HEALTH <= 0:
		return
	
	if event.is_action_pressed("player_camera_reset"):
		rotation_degrees.y = get_parent().rotation_degrees.y - 180
		rotation_degrees.x = -30
	
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * MOUSE_SENSITIVITY
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 30)
		
		rotation_degrees.y -= event.relative.x * MOUSE_SENSITIVITY
		rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
	
	if event is InputEventJoypadMotion:
		if event.axis == 2:#positive right negative left
			joystick_value_x = event.axis_value
		
		if event.axis == 3:
			joystick_value_y = event.axis_value
