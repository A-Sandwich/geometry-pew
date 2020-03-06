extends Area2D

onready var COMMON = get_node("/root/Common")
var sprite_width = 10
var color = Color(.5, .5, .5)
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_width = COMMON.screen_size.y / 10
	print("Ready", sprite_width)
	draw_and_add_collision()

func draw_and_add_collision():
	print("Drawing shape")
	var extent_vector = Vector2(-sprite_width, -sprite_width)
	var rect_size = Vector2(sprite_width * 2, sprite_width * 2)
	var shield_shape = Rect2(extent_vector, rect_size)
	draw_rect(shield_shape, color)
	$CollisionShape2D.shape.set_extents(extent_vector.abs())
