extends "BaseEnemy.gd"

func ready():
	color = Color(0, .55, .55, 0)

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
