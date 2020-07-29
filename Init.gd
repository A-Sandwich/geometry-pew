extends Node2D

onready var COMMON = get_node("/root/Common")
# Called when the node enters the scene tree for the first time.
func _ready():
	check_settings()
	get_tree().change_scene("res://Title.tscn")

func check_settings():
	var settings = COMMON.load_settings()
	if settings == null:
		return
	COMMON.infinite_lives = settings["infinite_lives"]
	COMMON.black_and_white = settings["black_and_white"]
	COMMON.apply_volume(settings["volume"])
