extends Area2D

const SPEED = 750

onready var COMMON = get_node("/root/Common")

signal location_change(position)

var BULLET = preload("res://bullets/Bullet.tscn")
var color = Color(0, 0, 0)
var dead = false
var motion = Vector2(0, 0)
var shots_fired = false
var sprite_width = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = COMMON.get_screen_size(self)
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	sprite_width = screen_size.x / 100

func _process(delta):
	input(delta)

func pew(velocity):
	if !shots_fired:
		var pew = BULLET.instance()
		pew.position.x += position.x + (velocity.x * sprite_width)
		pew.position.y = position.y + (velocity.y * sprite_width)
		pew.velocity = velocity.normalized() * pew.SPEED
		get_parent().add_child(pew)
		$ShotTimer.start()
		shots_fired = true

func input(delta):
	if dead:
		return
		
	var velocity = Vector2(0, 0)  # The player's movement vector.
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	move(delta, velocity)
	
	
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("fire_right"):
		velocity.x = 1
	if Input.is_action_pressed("fire_left"):
		velocity.x = -1
	if Input.is_action_pressed("fire_down"):
		velocity.y = 1
	if Input.is_action_pressed("fire_up"):
		velocity.y = -1
	if velocity.length() > 0:
		pew(velocity)
	

func move(delta, velocity):
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		emit_signal("location_change", position)
	position += velocity * delta
	var stage_size = get_parent().stage_size
	position.x = clamp(position.x, sprite_width, stage_size.x - sprite_width)
	position.y = clamp(position.y, sprite_width, stage_size.y - sprite_width)


func _draw():
	var geometry_points = PoolVector2Array()
	
	geometry_points = COMMON.get_square_points(geometry_points, sprite_width)
	$CollisionPolygon2D.polygon = geometry_points
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color)

func _on_Player_area_entered(area):
	print("COLLISION")
	color = Color(255, 0, 0)


func _on_ShotTimer_timeout():
	shots_fired = false
