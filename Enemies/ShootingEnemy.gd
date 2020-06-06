extends "BaseEnemy.gd"

var BULLET = preload("res://bullets/EnemyBullet.tscn")
var shooting = false
var time_since_last_shot = 0.0

func _init():
	color = Color(0.7, 0, 0.7)

func ready():
	speed = 220
	$Radar/RadarCollider.shape.radius = sprite_width * 20
	
func process(delta):
	if PLAYER.dead:
		return
	if !shooting:
		move(delta)
	elif shooting:
		shoot(delta)
		$ThrustParticle.emitting = false
	else:
		$ThrustParticle.emitting = false

func shoot(delta):
	time_since_last_shot += delta
	if time_since_last_shot > 0.5:
		var pew = BULLET.instance()
		pew.position = position
		pew.z_index = -100
		pew.sprite_width = sprite_width
		var direction = (player_position - position).normalized()
		var velocity = direction * pew.speed * delta
		pew.velocity = velocity.normalized() * pew.speed
		get_parent().add_child(pew)
		time_since_last_shot = 0

func draw_and_add_collision():
	var extent_vector = Vector2(-sprite_width, -sprite_width)
	var rect_size = Vector2(sprite_width * 2, sprite_width * 2)
	var enemy_shape = Rect2( extent_vector, rect_size)
	draw_rect(enemy_shape, color)
	$CollisionShape2D.shape.set_extents(extent_vector.abs())

func _on_Radar_area_entered(area):
	shooting = true

func _on_Radar_area_exited(area):
	shooting = false
