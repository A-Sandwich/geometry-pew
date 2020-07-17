extends Node2D

onready var COMMON = get_node("/root/Common")
onready var AUDIO = get_node("/root/Audio")

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
	screen_size = COMMON.get_screen_size(self)
	$CanvasLayer/HBoxContainer.rect_size = screen_size
	$CanvasLayer/HBoxContainer.update()
	$CanvasLayer/HBoxContainer/Options.rect_size = screen_size
	$CanvasLayer/HBoxContainer/Options.update()
	$CanvasLayer/HBoxContainer/Options/Resolutions.rect_size = Vector2(
		screen_size.x / 3, screen_size.y / 12
	)
	$CanvasLayer/HBoxContainer/Options/Resolutions.update()
	for index in range(len(resolutions)):
		$CanvasLayer/HBoxContainer/Options/Resolutions.add_item(str(resolutions[index]), index)
	$CanvasLayer/HBoxContainer/Options/MusicVolume.rect_size = Vector2(screen_size.x / 3, screen_size.y / 2)
	$CanvasLayer/HBoxContainer/Options/MusicVolume.update()



func _on_Apply_pressed():
	var selected_resolution = resolutions[$CanvasLayer/HBoxContainer/Options/Resolutions.get_selected_id()]
	if screen_size != selected_resolution:
		OS.set_window_size(selected_resolution)
		get_tree().root.get_viewport().set_size(selected_resolution);
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_EXPAND, selected_resolution);
		COMMON.screen_size = null
	AUDIO.volume_db = $CanvasLayer/HBoxContainer/Options/MusicVolume.value
	COMMON.black_and_white = $CanvasLayer/HBoxContainer/Options/BlackAndWhiteMode.toggle_mode
	get_tree().change_scene("res://Title.tscn")


func _on_InfiniteLives_toggled(button_pressed):
	COMMON.infinite_lives = $CanvasLayer/HBoxContainer/Options/InfiniteLives.toggle_mode


func _on_BlackAndWhiteMode_toggled(button_pressed):
	COMMON.black_and_white = $CanvasLayer/HBoxContainer/Options/BlackAndWhiteMode.toggle_mode
