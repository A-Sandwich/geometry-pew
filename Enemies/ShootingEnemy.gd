extends "BaseEnemy.gd"

var BULLET = preload("res://bullets/Bullet.tscn")
var shooting = false
var time_since_last_shot = 0.0

func ready():
	color = Color(0.7, 0, 0.7)
	speed = 200
	$Radar/RadarCollider.shape.radius = sprite_width * 12
	
func process(delta):
	if !PLAYER.dead and !shooting:
		move(delta)
	elif shooting:
		shoot(delta)
		$ThrustParticle.emitting = false
	else:
		$ThrustParticle.emitting = false

func shoot(delta):
	time_since_last_shot += delta
	if time_since_last_shot > 0.5:
		print("Delta inside", time_since_last_shot)
		var direction = (player_position - position).normalized()
		var pew = BULLET.instance()
		pew.sprite_width = sprite_width
		var velocity = direction * pew.speed
		pew.position.x += position.x + (velocity.x * sprite_width)
		pew.position.y = position.y + (velocity.y * sprite_width)
		#pew.multiplier = multiplier
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
	print(area.name)
	shooting = true

func _on_Radar_area_exited(area):
	shooting = false
