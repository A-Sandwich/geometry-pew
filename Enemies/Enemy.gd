extends Area2D

var color = Color(255, 0, 0)
var motion = Vector2(0, 0)
const SPEED = 200
var screen_size
var pace_direction_x = 1
var sprite_width
var point_value = 100
signal bullet_destroyed_enemy
var player_position
onready var HUD = get_parent().get_node("HUD")
onready var PLAYER = get_parent().get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = position.x + 100
	position.y = position.y + 100
	sprite_width = screen_size.x / 100
	player_position = screen_size / 2
	add_to_group("Enemy")
	self.connect("bullet_destroyed_enemy", HUD, "on_enemy_destroyed")
	if PLAYER != null:
		PLAYER.connect("location_change", self, "on_location_change")
	

func _process(delta):
	move(delta)

func move(delta):
	var velocity = Vector2()  # The enemy's movement vector.
	var direction = (player_position - position).normalized()

	velocity = direction * SPEED
	position += velocity * delta

func _draw():
	var geometry_points = PoolVector2Array()
	
	geometry_points = get_square_points(geometry_points)# draw operations are relative to the parent, so (0,0) is actually where the player is
	$CollisionPolygon2D.polygon = geometry_points
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color)

func get_square_points(geometry_points):
	geometry_points.push_back(Vector2(-sprite_width, -sprite_width))
	geometry_points.push_back(Vector2(sprite_width, -sprite_width))
	geometry_points.push_back(Vector2(sprite_width, sprite_width))
	geometry_points.push_back(Vector2(-sprite_width, sprite_width))
	geometry_points.push_back(Vector2(-sprite_width, -sprite_width))
	
	return geometry_points

func _on_Enemy_area_entered(area):
	if "Bullet" in area.name:
		emit_signal("bullet_destroyed_enemy", self, area)
	remove_from_group("Enemy")
	area.queue_free()

func on_location_change(position):
	player_position = position
