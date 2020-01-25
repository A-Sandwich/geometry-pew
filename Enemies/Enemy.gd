extends Area2D

onready var COMMON = get_node("/root/Common")
onready var HUD = get_parent().get_node("HUD")
var PLAYER

signal bullet_destroyed_enemy

var color = Color("DB2F2F")
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
	else:
		$ThrustParticle.emitting = false

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
	COMMON.thrust($ThrustParticle, velocity, sprite_width, position)

func _draw():
	var rect_size = Vector2(sprite_width * 2, sprite_width * 2)
	var bullet_shape = Rect2( Vector2(-sprite_width , -sprite_width), rect_size)
	draw_rect(bullet_shape, color)
	$CollisionShape2D.shape.extents = rect_size

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

func find_spawn_location():
	pass
