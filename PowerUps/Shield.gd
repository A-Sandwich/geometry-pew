extends Area2D

onready var COMMON = get_node("/root/Common")
var sprite_width = 100
var color = Color(.5, .5, .5)
signal power_up
var MOB

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_width = COMMON.screen_size.y / 100
	self.connect("power_up", MOB, "_on_power_up")

func _draw():
	draw_and_add_collision()

func draw_and_add_collision():
	var extent_vector = Vector2(-sprite_width, -sprite_width)
	var rect_size = Vector2(sprite_width * 2, sprite_width * 2)
	var shield_shape = Rect2(extent_vector, rect_size)
	draw_rect(shield_shape, color)
	$CollisionShape2D.shape.set_extents(extent_vector.abs())


func _on_Shield_area_entered(area):
	emit_signal("power_up")
