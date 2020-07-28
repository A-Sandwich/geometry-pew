extends Node2D

onready var COMMON = get_node("/root/Common")
onready var volume_element = $CanvasLayer/HBoxContainer/Options/VoluemControl/SpinBox
onready var resolutions_element = $CanvasLayer/HBoxContainer/Options/Resolutions
onready var black_and_white_element = $CanvasLayer/HBoxContainer/Options/BlackAndWhiteMode
onready var infinite_lives_element = $CanvasLayer/HBoxContainer/Options/InfiniteLives

var settings

var screen_size
var resolutions = [
	Vector2(5120, 1440),
	Vector2(4096, 2160),
	Vector2(4320, 1200),
	Vector2(1920,1080),
	Vector2(1280,720),
	Vector2(800,600)
]

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
	$CanvasLayer/HBoxContainer/Options/Resolutions.rect_size = Vector2(
		screen_size.x / 3, screen_size.y / 12
	)
	$CanvasLayer/HBoxContainer/Options/Resolutions.update()
	var resolution_index = resolutions.find(screen_size)
	if resolution_index < 0 and screen_size != null:
		resolutions.append(screen_size)
	for index in range(len(resolutions)):
		$CanvasLayer/HBoxContainer/Options/Resolutions.add_item(str(resolutions[index]), index)
	$CanvasLayer/HBoxContainer/Options/VoluemControl.rect_size = Vector2(screen_size.x / 3, screen_size.y / 2)
	$CanvasLayer/HBoxContainer/Options/VoluemControl.update()

	resolution_index = resolutions.find(screen_size)
	if resolution_index > -1:
		$CanvasLayer/HBoxContainer/Options/Resolutions.select(resolution_index)

func _on_Apply_pressed():
	var selected_resolution = resolutions[$CanvasLayer/HBoxContainer/Options/Resolutions.get_selected_id()]
	COMMON.apply_resolution(selected_resolution)
	COMMON.apply_volume(volume_element.value)
	save_to_file()
	get_tree().change_scene("res://Title.tscn")

func save_to_file():
	settings = {
		"resolution": resolutions[resolutions_element.get_selected_id()],
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
	var resolution_parts = settings["resolution"].split(", ")
	resolutions_element.select(resolutions.find(Vector2(resolution_parts[0], resolution_parts[1])))

func _on_InfiniteLives_toggled(button_pressed):
	COMMON.infinite_lives = button_pressed

func _on_BlackAndWhiteMode_toggled(button_pressed):
	COMMON.black_and_white = button_pressed

func _on_Cancel_pressed():
	settings = COMMON.load_settings()
	COMMON.infinite_lives = settings["infinite_lives"]
	COMMON.black_and_white = settings["black_and_white"]
	get_tree().change_scene("res://Title.tscn")
