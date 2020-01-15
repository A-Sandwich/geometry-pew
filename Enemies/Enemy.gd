extends Area2D

onready var COMMON = get_node("/root/Common")
onready var HUD = get_parent().get_node("HUD")
onready var PLAYER = get_parent().get_node("Player")

signal bullet_destroyed_enemy

var color = Color(255, 0, 0)
var motion = Vector2(0, 0)
var pace_direction_x = 1
var player_position
var point_value = 100
var speed = 200
var speed_range = Vector2(100, 550)
var sprite_width

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = position.x + 100
	position.y = position.y + 100
	sprite_width = COMMON.get_screen_size(self).x / 100
	player_position = COMMON.get_screen_size(self) / 2
	add_to_group("Enemy")
	self.connect("bullet_destroyed_enemy", HUD, "on_enemy_destroyed")
	if PLAYER != null:
		PLAYER.connect("location_change", self, "on_location_change")
	

func _process(delta):
	if !PLAYER.dead:
		move(delta)

func move(delta):
	var velocity = Vector2()  # The enemy's movement vector.
	var direction = (player_position - position).normalized()

	velocity = direction * speed
	position += velocity * delta
	
	
	var stage_size = get_parent().stage_size
	if (position.x < -sprite_width or position.x > stage_size.x + sprite_width or
		position.y < -sprite_width or position.y > stage_size.y + sprite_width):
		visible = false
	else:
		visible = true

func _draw():
	var geometry_points = PoolVector2Array()
	
	geometry_points = COMMON.get_square_points(geometry_points, sprite_width)# draw operations are relative to the parent, so (0,0) is actually where the player is
	$CollisionPolygon2D.polygon = geometry_points
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color)

func _on_Enemy_area_entered(area):
	if "Bullet" in area.name:
		emit_signal("bullet_destroyed_enemy", self, area)
	elif "Player" in area.name:
		area.dead = true
		return
	remove_from_group("Enemy")
	area.queue_free()

func on_location_change(position):
	player_position = position
