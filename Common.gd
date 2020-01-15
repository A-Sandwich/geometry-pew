extends Node

var rng = RandomNumberGenerator.new()
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	print("Stinky Man")

func get_square_points(geometry_points, length):
	# draw operations are relative to the parent, so (0,0) is actually where the player is
	geometry_points.push_back(Vector2(-length, -length))
	geometry_points.push_back(Vector2(length, -length))
	geometry_points.push_back(Vector2(length, length))
	geometry_points.push_back(Vector2(-length, length))
	geometry_points.push_back(Vector2(-length, -length))
	
	return geometry_points

# get_viewport_rect isn't possible in the ready method of an autoload script, so we'll just check and set/return
func get_screen_size(node):
	if screen_size == null:
		screen_size = node.get_viewport_rect().size
	return screen_size