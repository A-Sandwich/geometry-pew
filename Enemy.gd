extends Area2D

var color = Color(255, 0, 0)
var motion = Vector2(0, 0)
const SPEED = 200
var screen_size
var pace_direction_x = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = position.x + 100
	position.y = position.y + 100

func _process(delta):
	move(delta)

func move(delta):
	var velocity = Vector2()  # The enemy's movement vector.
	
	if (position.x > 300):
		pace_direction_x = -1
	elif (position.x < 100):
		pace_direction_x = 1
	
	velocity.x += pace_direction_x
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	position += velocity * delta

func _draw():
	var geometry_points = PoolVector2Array()
	
	geometry_points = get_square_points(geometry_points, position.x, position.y)
	$CollisionPolygon2D.polygon = geometry_points
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color)

func get_square_points(geometry_points, x, y):
	var sprite_width = screen_size.x / 100
	var center_x = x
	var center_y = y
	
	geometry_points.push_back(Vector2(center_x - sprite_width, center_y - sprite_width))
	geometry_points.push_back(Vector2(center_x + sprite_width, center_y - sprite_width))
	geometry_points.push_back(Vector2(center_x + sprite_width, center_y + sprite_width))
	geometry_points.push_back(Vector2(center_x - sprite_width, center_y + sprite_width))
	geometry_points.push_back(Vector2(center_x - sprite_width, center_y - sprite_width))
	
	return geometry_points