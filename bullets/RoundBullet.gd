extends "res://bullets/Bullet.gd"


func _ready():
	sprite_width = sprite_width / 2
	color = Color(1, 0, .45)

func draw():
	# RectangleShape2D extents (width and height) are a Vector2 and each extent
	# is multiplied by 2 to create the entire shape. To make the sizes of the Rect2
	# and RectangleShape2d match I made extent_vector 1/2 the size. Made it negative
	# so I could also use it as the start drawing location for the Rect 2. Rect2
	# Starts drawing from a corner while RectangleShape2D coordinates are from the center.
	#var extent_vector = Vector2(-sprite_width / 2, -sprite_width / 2)
	#var rect_size = Vector2(sprite_width, sprite_width)
	#var bullet_shape = Rect2( extent_vector, rect_size)
	if COMMON.black_and_white:
		color = Color(1, 1, 1)
	draw_circle(Vector2(0, 0), sprite_width, color)
	
	#draw_rect(bullet_shape, color, true)
	$CollisionShape2D.shape.radius = sprite_width
