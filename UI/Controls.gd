extends Node2D


var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	var controls = $UI/Controls
	screen_size = get_viewport_rect().size
	var size_constraint = screen_size.x
	var controls_size = controls.get_rect().size
	var scale = size_constraint / controls_size.x
	controls.scale = Vector2(scale, scale)
	controls.position = Vector2((controls_size.x * scale) / 2,  (controls_size.y * scale) / 2)

func _process(delta):
	# wow, such beauty
	if (Input.is_action_just_pressed("bomb") or 
	 Input.is_action_just_pressed("thrust") or
	 Input.is_action_just_pressed("up") or
	 Input.is_action_just_pressed("down") or
	 Input.is_action_just_pressed("left") or
	 Input.is_action_just_pressed("right") or
	 Input.is_action_just_pressed("fire_up") or
	 Input.is_action_just_pressed("fire_down") or
	 Input.is_action_just_pressed("fire_left") or
	 Input.is_action_just_pressed("fire_right") or
	 Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://Stage.tscn")
