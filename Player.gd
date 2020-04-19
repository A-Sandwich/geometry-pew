extends Area2D

const SPEED = 550
const FULL_ENERGY = 225
const ENERGY_DEPLETION_MULTIPLIER = 100
const ENERGY_RECHARGE_MULTIPLIER = 10

onready var COMMON = get_node("/root/Common")
onready var STAGE = get_node("/root/Stage")

signal bomb_detonated()
signal bombs_left(amount)

var DEFAULT_STARTING_BOMBS = 3
var BULLET = preload("res://bullets/Bullet.tscn")
var ROUND_BULLET = preload("res://bullets/RoundBullet.tscn")
var color = Color(.03, 0.5, 1)
var dead = false
var motion = Vector2(0, 0)
var shots_fired = false
var sprite_width = 0
var screen_size
var bombs_left = 0
var cannot_detonate = false
var energy = FULL_ENERGY
var thrusting = false
var draw_state_dirty = false
var title = true
var multiplier = 1
var SHOT_TIMER_BASE = 0.15

func _ready():
	ready()

func ready():
	screen_size = COMMON.get_screen_size(self)
	if STAGE == null:
		position.x = screen_size.x / 2
		position.y = screen_size.y / 2
		sprite_width = screen_size.x / 75
	else:
		position.x = STAGE.stage_size.x / 2
		position.y = STAGE.stage_size.y / 2
		sprite_width = STAGE.stage_size.y / 200
	set_bombs_left()
	set_collision_shape()

func _process(delta):
	process(delta)

func process(delta):
	if title:
		return
	input(delta)
	if draw_state_dirty:
		draw_state_dirty = false
		update()

func pew(velocity):
	if !shots_fired:
		multiplier = 4
		if (multiplier > 3):
			var position1 = position
			var position2 = position
			
			if (velocity.x != 0 && velocity.y != 0):
				position1.x += sprite_width / 2
				position2.x -= sprite_width / 2
				position1.y += sprite_width / 2
				position2.y += sprite_width / 2
			
			if (velocity.x == 0):
				position1.x += sprite_width
				position2.x -= sprite_width
			if (velocity.y == 0):
				position1.y += sprite_width
				position2.y -= sprite_width
			
			var pew1 = ROUND_BULLET.instance().init(position1, velocity, sprite_width,
			multiplier)
			var pew2 = ROUND_BULLET.instance().init(position2, velocity, sprite_width,
			multiplier)
			pew1.speed = 0.1
			pew2.speed = 0.1
			get_parent().add_child(pew1)
			#get_parent().add_child(pew2)
		else:
			var pew = ROUND_BULLET.instance().init(position, velocity, sprite_width,
			multiplier)
			get_parent().add_child(pew)
		$ShotTimer.start()
		shots_fired = true
		#pew_noise()


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
	var initial_energy = energy
	var speed = SPEED
	if Input.is_action_pressed("thrust") and energy > 0 and $ThrustTimeout.is_stopped():
		thrusting = true
		speed = 2 * SPEED
		var used_energy = delta * ENERGY_DEPLETION_MULTIPLIER
		energy -= used_energy if used_energy < energy else energy
	else:
		if energy <= 0 and $ThrustTimeout.is_stopped():
			$ThrustTimeout.start()
		energy += delta * ENERGY_RECHARGE_MULTIPLIER if energy < FULL_ENERGY else 0
		thrusting = false
		
	if initial_energy != energy:
		draw_state_dirty = true
	return speed

func _draw():
	var geometry_points = PoolVector2Array()
	geometry_points = COMMON.get_square_points(geometry_points, sprite_width)
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color)
	
	draw_rect(get_energy_shape(), color)

func get_energy_shape():
	var energy_left_ratio = (energy / FULL_ENERGY)
	var extent_vector = Vector2(-sprite_width, -sprite_width * energy_left_ratio)
	var rect_size = Vector2(sprite_width * 2, sprite_width * 2 * energy_left_ratio)
	var energy_shape = Rect2( extent_vector, rect_size)
	return energy_shape

func set_collision_shape():
	var geometry_points = PoolVector2Array()
	geometry_points = COMMON.get_square_points(geometry_points, sprite_width)
	$CollisionPolygon2D.polygon = geometry_points

func start():
	dead = false

func set_bombs_left(bombs_left = DEFAULT_STARTING_BOMBS):
	self.bombs_left = bombs_left
	emit_signal("bombs_left", self.bombs_left)

func reset():
	position.x = screen_size.x / 2
	position.y = screen_size.y / 2
	set_bombs_left()
	self.visible = true

func _on_BombTimer_timeout():
	cannot_detonate = false
	$BombTimer.stop()

func _on_Player_area_entered(area):
	color = Color(.03, 0.5, 1)
	if area.name == "EnemyBullet" and !thrusting:
		die()

func die():
	dead = true
	var explosion = COMMON.generate_explosion(position)
	get_parent().add_child(explosion)
	explosion.particles_explode = true
	self.visible = false

func _on_ShotTimer_timeout():
	shots_fired = false

func _on_ThrustTimeout_timeout():
	$ThrustTimeout.stop()

func apply_multiplier(updated_multiplier):
	multiplier = updated_multiplier
	$ShotTimer.wait_time = SHOT_TIMER_BASE / multiplier
