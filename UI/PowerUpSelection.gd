extends MarginContainer
onready var COMMON = get_node("/root/Common")
onready var PAUSE_MENU = get_node("/root/Stage/PauseMenu")
onready var BACKGROUND = get_node("/root/Stage/BackgroundCanvas/Background")
onready var option_one = $VBoxContainer/HBoxContainer/OptionOne
onready var option_two = $VBoxContainer/HBoxContainer/OptionTwo
onready var size = get_viewport().get_visible_rect().size
onready var quarter_x = size.x / 4
onready var twentieth_Y = size.y / 10
var shrink_ship_texture = preload("res://Resources/Images/shrink-ship.png")
var increase_bullet_size = preload("res://Resources/Images/increase-bullet-size.png")
var extra_bomb = preload("res://Resources/Images/Bomb.png")
var longer_boost = preload("res://Resources/Images/extra-boost.png")
var option_one_content_index
var option_two_content_index
signal power_up(power)

var POWER_UP_OPTIONS = [ # Consider moving this to it's own json file or class to clean this file up
	{
		"name": "shrink_ship",
		"description": "Shrink the size of your ship",
		"texture": shrink_ship_texture
	}, 
	{
		"name": "increase_bullet_size",
		"description": "Increase the size of bullets",
		"texture": increase_bullet_size
	},
	{
		"name": "extra_bomb",
		"description": "Gain an extra bomb",
		"texture": extra_bomb
	},
	{
		"name": "longer_boost",
		"description": "Boost for longer",
		"texture": longer_boost
	}
]

func _ready():
	visible = false
	update_texture_size(option_one.get_child(0), quarter_x)
	update_texture_size(option_two.get_child(0), quarter_x)
	margin_top = twentieth_Y
	margin_bottom = twentieth_Y
	margin_left = quarter_x
	margin_right = quarter_x
	update()

func _process(delta):
	if Input.is_action_just_pressed("power_up"):
		start_selection()

func start_selection():
	BACKGROUND.visible = true
	update()
	randomize_options()
	visible = true
	get_tree().paused = true

func update_texture_size(texture, size):
	texture.rect_min_size = Vector2(size, size)
	texture.update()

func randomize_options():
	option_one_content_index = COMMON.rng.randi_range(0, len(POWER_UP_OPTIONS) - 1)
	option_two_content_index = option_one_content_index
	while option_one_content_index == option_two_content_index:
		option_two_content_index = COMMON.rng.randi_range(0, len(POWER_UP_OPTIONS) - 1)
	update_option(option_one, POWER_UP_OPTIONS[option_one_content_index])
	update_option(option_two, POWER_UP_OPTIONS[option_two_content_index])

func update_option(option, content):
	for child in option.get_children():
		if child.name == "TextureRect":
			child.set_texture(content["texture"])
		elif child.name == "Description":
			child.text = content["description"]
		elif child.name == "SelectOption":
			pass

func resume():
	if PAUSE_MENU.is_visible():
		return
	visible = false
	BACKGROUND.visible = false
	get_tree().paused = false

func _on_SelectOptionOne_pressed():
	emit_power_up_and_cleanup(POWER_UP_OPTIONS[option_one_content_index]["name"])

func _on_SelectOptionTwo_pressed():
	emit_power_up_and_cleanup(POWER_UP_OPTIONS[option_two_content_index]["name"])

func emit_power_up_and_cleanup(power_up_name):
	emit_signal("power_up", power_up_name.replace("_", " "))
	resume()

func _on_Cancel_pressed():
	resume()
