extends Area2D

var speed = 800

onready var COMMON = get_node("/root/Common")

var color = Color(255, 255, 0, 0.05)
var motion = Vector2(0, 0)
var pace_direction_x = 1
var sprite_width
var velocity = Vector2()  # The enemy's movement vector.
var multiplier = 1
var screen_size

func init(position, velocity, sprite_width, multiplier):
	self.sprite_width = sprite_width
	self.position.x += position.x + (velocity.x * self.sprite_width)
	self.position.y = position.y + (velocity.y * self.sprite_width)
	self.multiplier = multiplier
	self.velocity = velocity.normalized() * self.speed
	return self

func _ready():
	ready()
func ready():
	screen_size = COMMON.get_screen_size(self) # if function call overhead is too high then set in _ready()

func _process(delta):
	move(delta)

func move(delta):
	velocity = velocity.normalized() * speed
	position += velocity * delta
	var stage_size = get_parent().stage_size
	if (position.x < 0 or position.x > stage_size.x or
		position.y < 0 or position.y > stage_size.y):
			self.queue_free() # RIP

func _draw():
	draw()
	
func draw():
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
	on_bullet_area_entered(area)

func on_bullet_area_entered(area):
	print("bullet Area entered "+ str(OS.get_ticks_msec()) + " " + area.name)
	if area.name != "Radar":
		speed = 0
		self.queue_free()
