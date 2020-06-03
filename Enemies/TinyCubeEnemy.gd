extends "BaseEnemy.gd"

var zag_direction = 1
var DISTANCE_TO_RUSH = 0
var zig_zag_rotation = 0
var ZIG_ZAG_ROTATION_MAX = 0.125
var ZIG_ZAG_ROTATION_INCREASE = 0.08

func ready():
	color = Color(0.02, .9, .08)
	sprite_width = sprite_width * 0.7
	DISTANCE_TO_RUSH = sprite_width * 2

func process(delta):
	if !PLAYER.dead:
		move(delta)
	else:
		$ThrustParticle.emitting = false

func draw_and_add_collision():
	var extent_vector = Vector2(-sprite_width, -sprite_width)
	var rect_size = Vector2(sprite_width * 2, sprite_width * 2)
	var enemy_shape = Rect2( extent_vector, rect_size)
	draw_rect(enemy_shape, color)
	$CollisionShape2D.shape.set_extents(extent_vector.abs())

func zig_zag(direction):
	var new_direction = direction.rotated(PI * zig_zag_rotation)
	return new_direction

func move(delta):
	var velocity = Vector2()  # The enemy's movement vector.
	var direction = (player_position - position).normalized()
	
	if position.distance_to(PLAYER.position) > DISTANCE_TO_RUSH: 
		direction = zig_zag(direction)
	
	var temp_position = position + (velocity * delta)
	var stage_size = get_parent().stage_size
	var double_sprite_width = sprite_width * 4
	if (temp_position.x < sprite_width or temp_position.x > stage_size.x - sprite_width or
		temp_position.y < sprite_width or temp_position.y > stage_size.y - sprite_width):
		velocity = get_direction_towards_player() * speed
	else:
		velocity = direction * speed
	position += velocity * delta
	COMMON.thrust($ThrustParticle, direction * speed * delta, sprite_width, position)


func _on_ZigZagTimer_timeout():
	zag_direction *= -1


func _on_RotationTimer_timeout():
	var rotation_result = zag_direction * ZIG_ZAG_ROTATION_INCREASE
	if rotation_result <= ZIG_ZAG_ROTATION_MAX && rotation_result >= -ZIG_ZAG_ROTATION_MAX:
		zig_zag_rotation += rotation_result
	rotate(0.2)
