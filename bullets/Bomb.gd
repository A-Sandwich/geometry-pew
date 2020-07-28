extends Area2D

const GROW_RATE = 5000
onready var COMMON = get_node("/root/Common")
var sprite_width = 10
var color = Color(1, 1, 1)
var max_size = 0

func _ready():
	var stage_size = get_parent().stage_size
	max_size = stage_size.x * 2

func _process(delta):
	if sprite_width > max_size:
		print("FREEING BOMB")
		queue_free()
	sprite_width = sprite_width + GROW_RATE * delta
	$CollisionShape2D.shape.extents = Vector2(sprite_width, sprite_width)
	update()

func _draw():
	if COMMON.black_and_white:
		color = Color(1, 1, 1)
	var geometry_points = PoolVector2Array()
	geometry_points = COMMON.get_square_points(geometry_points, sprite_width)
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color, 10)
