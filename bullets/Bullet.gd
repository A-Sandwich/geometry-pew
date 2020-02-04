extends Area2D

const SPEED = 750

onready var COMMON = get_node("/root/Common")

var color = Color(255, 255, 0)
var motion = Vector2(0, 0)
var pace_direction_x = 1
var sprite_width
var velocity = Vector2()  # The enemy's movement vector.

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_width = COMMON.get_screen_size(self).x / 200

func _process(delta):
	var screen_size = COMMON.get_screen_size(self) # if function call overhead is too high then set in _ready()
	if (position.x > screen_size.x || position.y > screen_size.y):
		pass#dafuq is this?
	move(delta)

func move(delta):
	velocity = velocity.normalized() * SPEED
	position += velocity * delta
	var stage_size = get_parent().stage_size
	if (position.x < 0 or position.x > stage_size.x or
		position.y < 0 or position.y > stage_size.y):
			self.queue_free() # RIP
			

func _draw():
	# RectangleShape2D extents (width and height) are a Vector2 and each extent
	# is multiplied by 2 to create the entire shape. To make the sizes of the Rect2
	# and RectangleShape2d match I made extent_vector 1/2 the size. Made it negative
	# so I could also use it as the start drawing location for the Rect 2. Rect2
	# Starts drawing from a corner while RectangleShape2D coordinates are from the center.
	var extent_vector = Vector2(-sprite_width / 2, -sprite_width / 2)
	var rect_size = Vector2(sprite_width, sprite_width)
	var bullet_shape = Rect2( extent_vector, rect_size)
	draw_rect(bullet_shape, color, true)
	$CollisionShape2D.shape.set_extents(extent_vector.abs())

func _on_Bullet_area_entered(area):
	print("Bullet entered")
	area.queue_free()
	self.queue_free()
