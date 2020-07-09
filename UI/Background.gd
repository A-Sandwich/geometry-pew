extends Node2D


var screen_size


func _ready():
	pass # Replace with function body.

func _draw():
	draw_rect(Rect2(Vector2(0,0), screen_size), Color(0, 0, 0, 0.5), true, false)
