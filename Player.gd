extends Area2D

const SPEED = 550

onready var COMMON = get_node("/root/Common")

signal bomb_detonated()
signal bombs_left(amount)

var DEFAULT_STARTING_BOMBS = 3
var BULLET = preload("res://bullets/Bullet.tscn")
var color = Color(0, 0, 0)
var dead = false
var motion = Vector2(0, 0)
var shots_fired = false
var sprite_width = 0
var screen_size
var bombs_left = 0
var cannot_detonate = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = COMMON.get_screen_size(self)
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	sprite_width = screen_size.x / 100
	set_bombs_left()

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
		$ThrustParticle.emitting = false
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
	COMMON.thrust($ThrustParticle, velocity, sprite_width, position)
	
	
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
	
	if Input.is_action_just_pressed("bomb"):
		explode()

func explode():
	if cannot_detonate or bombs_left < 1:
		return
	cannot_detonate = true
	$BombTimer.start()
	set_bombs_left(bombs_left - 1)
	emit_signal("bombs_left", bombs_left)
	emit_signal("bomb_detonated")

func move(delta, velocity):
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
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

func start():
	dead = false

func set_bombs_left(bombs_left = DEFAULT_STARTING_BOMBS):
	self.bombs_left = bombs_left
	emit_signal("bombs_left", self.bombs_left)

func reset():
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	set_bombs_left()

func _on_BombTimer_timeout():
	cannot_detonate = false
	$BombTimer.stop()

func _on_Player_area_entered(area):
	color = Color(.03, 0.5, 1)


func _on_ShotTimer_timeout():
	shots_fired = false
