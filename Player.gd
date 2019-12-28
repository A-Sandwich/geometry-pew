extends Area2D

var screen_width = 1920
var screen_height = 1080
var color = Color(0, 0, 0)
var motion = Vector2(0, 0)
const SPEED = 750
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	move(delta)

func move(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _draw():
	var geometry_points = PoolVector2Array()
	var parent = get_parent()
	
	geometry_points = get_square_points(geometry_points, position.x, position.y)
	$CollisionPolygon2D.polygon = geometry_points
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color)

func get_square_points(geometry_points, x, y):
	var sprite_width = screen_width / 100
	var center_x = x
	var center_y = y
	
	geometry_points.push_back(Vector2(center_x - sprite_width, center_y - sprite_width))
	geometry_points.push_back(Vector2(center_x + sprite_width, center_y - sprite_width))
	geometry_points.push_back(Vector2(center_x + sprite_width, center_y + sprite_width))
	geometry_points.push_back(Vector2(center_x - sprite_width, center_y + sprite_width))
	geometry_points.push_back(Vector2(center_x - sprite_width, center_y - sprite_width))
	
	return geometry_points

func _on_Player_area_entered(area):
	print("COLLISION")
	color = Color(255, 0, 0)
