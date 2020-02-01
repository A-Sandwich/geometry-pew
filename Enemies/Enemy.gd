extends "BaseEnemy.gd"

	
func ready():
	pass

func process(delta):
	if !PLAYER.dead:
		move(delta)
	else:
		$ThrustParticle.emitting = false

func draw_and_add_collision():
	var rect_size = Vector2(sprite_width * 2, sprite_width * 2)
	var bullet_shape = Rect2( Vector2(-sprite_width , -sprite_width), rect_size)
	draw_rect(bullet_shape, color)
	$CollisionShape2D.shape.extents = rect_size
