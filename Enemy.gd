extends Area2D

var color = Color(0, 0, 0)
var motion = Vector2(0, 0)
const SPEED = 750
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

#func _process(delta):

func _draw():
	var geometry_points = PoolVector2Array()
	var parent = get_parent()
	
	geometry_points = get_square_points(geometry_points, position.x + 400, position.y - 400)
	$CollisionPolygon2D.polygon = geometry_points
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color)

func get_square_points(geometry_points, x, y):
	var sprite_width = 100
	var center_x = x
	var center_y = y
	
	geometry_points.push_back(Vector2(center_x - sprite_width, center_y - sprite_width))
	geometry_points.push_back(Vector2(center_x + sprite_width, center_y - sprite_width))
	geometry_points.push_back(Vector2(center_x + sprite_width, center_y + sprite_width))
	geometry_points.push_back(Vector2(center_x - sprite_width, center_y + sprite_width))
	geometry_points.push_back(Vector2(center_x - sprite_width, center_y - sprite_width))
	
	return geometry_points