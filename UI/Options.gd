extends Node2D

onready var COMMON = get_node("/root/Common")
onready var volume_element = $CanvasLayer/HBoxContainer/Options/VoluemControl/SpinBox
onready var black_and_white_element = $CanvasLayer/HBoxContainer/Options/BlackAndWhiteMode
onready var infinite_lives_element = $CanvasLayer/HBoxContainer/Options/InfiniteLives

var settings
var screen_size

func _ready():
	settings = COMMON.load_settings() 
	if settings == null:
		save_to_file()
	else:
		apply_previous_settings()
	screen_size = COMMON.screen_size
	$CanvasLayer/HBoxContainer.rect_size = screen_size
	$CanvasLayer/HBoxContainer.update()
	$CanvasLayer/HBoxContainer/Options.rect_size = screen_size
	$CanvasLayer/HBoxContainer/Options.update()
	$CanvasLayer/HBoxContainer/Options/VoluemControl.rect_size = Vector2(screen_size.x / 3, screen_size.y / 2)
	$CanvasLayer/HBoxContainer/Options/VoluemControl.update()

func _on_Apply_pressed():
	COMMON.apply_volume(volume_element.value)
	save_to_file()
	get_tree().change_scene("res://Title.tscn")

func save_to_file():
	settings = {
		"infinite_lives": COMMON.infinite_lives,
		"black_and_white": COMMON.black_and_white,
		"volume": volume_element.value
	}
	COMMON.save_settings(settings)

func apply_previous_settings():
	if settings == null:
		return
	COMMON.infinite_lives = settings["infinite_lives"]
	infinite_lives_element.pressed = settings["infinite_lives"]
	COMMON.black_and_white = settings["black_and_white"]
	black_and_white_element.pressed = settings["black_and_white"]
	black_and_white_element.update()
	volume_element.value = settings["volume"]

func _on_InfiniteLives_toggled(button_pressed):
	COMMON.infinite_lives = button_pressed

func _on_BlackAndWhiteMode_toggled(button_pressed):
	COMMON.black_and_white = button_pressed

func _on_Cancel_pressed():
	settings = COMMON.load_settings()
	COMMON.infinite_lives = settings["infinite_lives"]
	COMMON.black_and_white = settings["black_and_white"]
	get_tree().change_scene("res://Title.tscn")
