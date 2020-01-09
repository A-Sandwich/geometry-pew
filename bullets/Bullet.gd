extends Area2D

var color = Color(255, 255, 0)
var motion = Vector2(0, 0)
const SPEED = 1000
var screen_size
var pace_direction_x = 1
var velocity = Vector2()  # The enemy's movement vector.
var sprite_width

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	sprite_width = screen_size.x / 300

func _process(delta):
	if (position.x > screen_size.x || position.y > screen_size.y):
		pass
	move(delta)

func move(delta):
	velocity = velocity.normalized() * SPEED
	position += velocity * delta
	if (position.x < 0 or position.x > screen_size.x or
		position.y < 0 or position.y > position.y):
			self.queue_free() # RIP
			

func _draw():
	var geometry_points = PoolVector2Array()
	
	geometry_points = get_square_points(geometry_points)
	$CollisionPolygon2D.polygon = geometry_points
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color)

func get_square_points(geometry_points):
	# draw operations are relative to the parent, so (0,0) is actually where the player is
	geometry_points.push_back(Vector2(-sprite_width, -sprite_width))
	geometry_points.push_back(Vector2(sprite_width, -sprite_width))
	geometry_points.push_back(Vector2(sprite_width, sprite_width))
	geometry_points.push_back(Vector2(-sprite_width, sprite_width))
	geometry_points.push_back(Vector2(-sprite_width, -sprite_width))
	
	return geometry_points

func _on_Bullet_area_entered(area):
	area.queue_free()
