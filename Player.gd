extends Area2D

const SPEED = 550
const ENERGY_DEPLETION_MULTIPLIER = 100
const ENERGY_RECHARGE_MULTIPLIER = 10

onready var COMMON = get_node("/root/Common")
onready var STAGE = get_node("/root/Stage")

signal bomb_detonated()
signal player_death()
signal bombs_left(amount)

var FULL_ENERGY = 225
var DEFAULT_STARTING_BOMBS = 3
var BULLET = preload("res://bullets/Bullet.tscn")
var ROUND_BULLET = preload("res://bullets/RoundBullet.tscn")
var color = Color(.03, 0.5, 1)
var dead = false
var motion = Vector2(0, 0)
var shots_fired = false
var sprite_width = 0
var bullet_size = 0
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
	dead = true # this is for the countdown. (I should rename this)
	screen_size = COMMON.get_screen_size(self)
	if STAGE == null:
		position.x = screen_size.x / 2
		position.y = screen_size.y / 2
		sprite_width = screen_size.x / 75
	else:
		position.x = STAGE.stage_size.x / 2
		position.y = STAGE.stage_size.y / 2
		sprite_width = screen_size.y / 100
	bullet_size = sprite_width
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
		var pew = ROUND_BULLET.instance().init(position, velocity, bullet_size,
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
	
	if Input.is_action_just_pressed("jump"):
		jump()
		return
	
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

func jump():
	pass

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

func _on_BombTimer_timeout():
	cannot_detonate = false
	$BombTimer.stop()

func _on_Player_area_entered(area):
	color = Color(.03, 0.5, 1)
	print("Player area entered " + area.name)
	if "EnemyBullet" in area.name and !thrusting:
		die()

func die():
	if COMMON.infinite_lives:
		return
	dead = true
	self.visible = false
	emit_signal("player_death")

func _on_ShotTimer_timeout():
	shots_fired = false

func _on_ThrustTimeout_timeout():
	$ThrustTimeout.stop()

func apply_multiplier(updated_multiplier):
	multiplier = updated_multiplier
	# todo balance this with power ups (I think the best solution might be to 
	# just hardcode an array with the different times instead
	$ShotTimer.wait_time = SHOT_TIMER_BASE * ((2 / multiplier) if multiplier > 1 else 1) # fuckin' python ternarys... am I right?
const POWER_UP_OPTIONS = ["shrink_ship", "increase_bullet_size", "extra_bomb", "longer_boost"]
func on_power_up(power_up_type):
	print("pwer "+power_up_type)
	print(power_up_type)
	if power_up_type == "shrink ship":
		sprite_width = sprite_width * 0.9
	elif power_up_type == "increase bullet size":
		bullet_size = bullet_size * 1.25
	elif power_up_type == "extra bomb":
		bombs_left += 1
		emit_signal("bombs_left", bombs_left)
	elif power_up_type == "longer_boost":
		FULL_ENERGY += 50
	self.update()
