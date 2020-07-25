extends MarginContainer
onready var COMMON = get_node("/root/Common")
onready var option_one = $VBoxContainer/HBoxContainer/OptionOne
onready var option_two = $VBoxContainer/HBoxContainer/OptionTwo
onready var size = get_viewport().get_visible_rect().size
onready var quarter_x = size.x / 4
onready var twentieth_Y = size.y / 20
var shrink_ship_texture = preload("res://Resources/Images/shrink-ship.png")
var increase_bullet_size = preload("res://Resources/Images/increase-bullet-size.png")
var extra_bomb = preload("res://Resources/Images/Bomb.png")
var longer_boost = preload("res://Resources/Images/extra-boost.png")

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
	randomize_options()
	update_texture_size(option_one.get_child(0), quarter_x)
	update_texture_size(option_two.get_child(0), quarter_x)
	margin_top = twentieth_Y
	margin_bottom = twentieth_Y
	margin_left = quarter_x
	margin_right = quarter_x
	update()

func update_texture_size(texture, size):
	texture.rect_min_size = Vector2(size, size)
	texture.update()

func randomize_options():
	var option_one_content = COMMON.rng.randi_range(0, len(POWER_UP_OPTIONS) - 1)
	var option_two_content = option_one_content
	while option_one_content == option_two_content:
		option_two_content = COMMON.rng.randi_range(0, len(POWER_UP_OPTIONS) - 1)
	update_option(option_one, POWER_UP_OPTIONS[option_one_content])
	update_option(option_two, POWER_UP_OPTIONS[option_two_content])

func update_option(option, content):
	for child in option.get_children():
		if child.name == "TextureRect":
			child.set_texture(content["texture"])
		elif child.name == "Description":
			child.text = content["description"]
		elif child.name == "SelectOption":
			pass
