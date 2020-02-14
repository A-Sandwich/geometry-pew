extends Area2D

const SPEED = 550
const FULL_ENERGY = 100
const ENERGY_DEPLETION_MULTIPLIER = 100
const ENERGY_RECHARGE_DIVISOR = 2

onready var COMMON = get_node("/root/Common")
onready var STAGE = get_node("/root/Stage")

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
var energy = FULL_ENERGY
var thrusting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = COMMON.get_screen_size(self)
	position.x = STAGE.stage_size.x / 2
	position.y = STAGE.stage_size.y / 2
	sprite_width = STAGE.stage_size.x / 200
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
		pew_noise()

func pew_noise():
	$PewNoise.play()

func input(delta):
	if dead:
		$ThrustParticle.emitting = false
		return
		
	var velocity = Vector2(0, 0)  # The player's movement vector.
	if Input.is_action_pressed("right"):
		velocity.x += Input.get_action_strength("right")
	if Input.is_action_pressed("left"):
		velocity.x -= Input.get_action_strength("left")
	if Input.is_action_pressed("down"):
		velocity.y += Input.get_action_strength("down")
	if Input.is_action_pressed("up"):
		velocity.y -= Input.get_action_strength("up")
	move(delta, velocity)
	COMMON.thrust($ThrustParticle, velocity, sprite_width, position)
	
	
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("fire_right"):
		velocity.x = Input.get_action_strength("fire_right")
	if Input.is_action_pressed("fire_left"):
		velocity.x -= Input.get_action_strength("fire_left")
	if Input.is_action_pressed("fire_down"):
		velocity.y += Input.get_action_strength("fire_down")
	if Input.is_action_pressed("fire_up"):
		velocity.y -= Input.get_action_strength("fire_up")
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
	var speed = thrust(delta)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	var stage_size = get_parent().stage_size
	position.x = clamp(position.x, sprite_width, stage_size.x - sprite_width)
	position.y = clamp(position.y, sprite_width, stage_size.y - sprite_width)

func thrust(delta):
	var speed = SPEED
	if Input.is_action_pressed("thrust") and energy > 0 and $ThrustTimeout.is_stopped():
		thrusting = true
		speed = 2 * SPEED
		var used_energy = delta * ENERGY_DEPLETION_MULTIPLIER
		energy -= used_energy if used_energy < energy else energy
	else:
		if energy <= 0 and $ThrustTimeout.is_stopped():
			$ThrustTimeout.start()
		energy += delta / ENERGY_RECHARGE_DIVISOR if energy < FULL_ENERGY else 0
		thrusting = false
	print(energy)
	return speed

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


func _on_ThrustTimeout_timeout():
	$ThrustTimeout.stop()
