extends Node2D

onready var COMMON = get_node("/root/Common")
var screen_size


func _ready():
	screen_size = COMMON.get_screen_size(self)
	visible = false

func _draw():
	draw_rect(Rect2(Vector2(0,0), screen_size), Color(0, 0, 0, 0.5), true, false)
