extends MarginContainer

const DEFAULT_COLOR = Color(1, 1, 1, 0.8)
const HOVER_COLOR = Color(1, 1, 1, 1)
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
var debugging = false
var focus
signal power_up(power)

var ui_elements

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
	#visible = false
	update_texture_size(option_one.get_child(0), quarter_x)
	update_texture_size(option_two.get_child(0), quarter_x)
	margin_top = twentieth_Y
	margin_bottom = twentieth_Y
	margin_left = quarter_x
	margin_right = quarter_x
	ui_elements = [
		get_node("VBoxContainer/HBoxContainer/OptionOne/SelectOptionOne"),
		get_node("VBoxContainer/HBoxContainer/OptionTwo/SelectOptionTwo"),
		get_node("VBoxContainer/Cancel")
	]
	$VBoxContainer/HBoxContainer/OptionOne/SelectOptionOne.modulate = DEFAULT_COLOR
	$VBoxContainer/HBoxContainer/OptionTwo/SelectOptionTwo.modulate = DEFAULT_COLOR
	$VBoxContainer/Cancel.modulate = DEFAULT_COLOR
	update()

func _process(delta):
	if debugging and Input.is_action_just_pressed("power_up"):
		start_selection()
	if Input.is_action_just_pressed("ui_up"):
		if focus == ui_elements[2]:
			on_entered(ui_elements[1])
	elif Input.is_action_just_pressed("ui_down"):
		if focus == ui_elements[0] or focus == ui_elements[1]:
			on_entered(ui_elements[2])
		else:
			on_entered(ui_elements[0])
	elif Input.is_action_just_pressed("ui_left"):
		if focus == ui_elements[1]:
			on_entered(ui_elements[0])
	elif Input.is_action_just_pressed("ui_right"):
		if focus == ui_elements[0]:
			on_entered(ui_elements[1])
	elif Input.is_action_just_pressed("ui_focus_next"):
		if focus == ui_elements[0]:
			on_entered(ui_elements[1])
		elif focus == ui_elements[1]:
			on_entered(ui_elements[2])
		else:
			on_entered(ui_elements[0])
	elif Input.is_action_just_pressed("ui_focus_prev"):
		if focus == ui_elements[1]:
			on_entered(ui_elements[0])
		elif focus == ui_elements[2]:
			on_entered(ui_elements[1])
	if Input.is_action_just_pressed("ui_accept"):
		if focus != null:
			focus.emit_signal("pressed")

func on_entered(button):
	if focus != null and button != focus:
		print("last focus" + str(focus.name) +  " New focus "+button.name)
		on_exited(focus)
	focus = button
	button.modulate = HOVER_COLOR

func on_exited(button):
	button.modulate = DEFAULT_COLOR

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

func on_wave_change(wave):
	start_selection()

func _on_SelectOptionTwo_mouse_entered():
	on_entered(ui_elements[1])

func _on_SelectOptionTwo_mouse_exited():
	on_exited(ui_elements[1])

func _on_Cancel_mouse_entered():
	on_entered(ui_elements[2])

func _on_Cancel_mouse_exited():
	on_exited(ui_elements[2])

func _on_SelectOptionOne_mouse_entered():
	print(ui_elements)
	on_entered(ui_elements[0])

func _on_SelectOptionOne_mouse_exited():
	on_exited(ui_elements[0])
