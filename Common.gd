extends Node

var rng = RandomNumberGenerator.new()
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	ready()
func ready():
	rng.randomize()
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

func thrust(particle_node, velocity, sprite_width, position, display = true):
	if (velocity.length() <= 0 or !display):
		particle_node.emitting = false
		return
	else:
		particle_node.emitting = true
		
	velocity.x = -velocity.x
	velocity.y = -velocity.y
	
	var new_thrust_x = sprite_width * clamp(velocity.x, -1, 1)
	var new_thrust_y = sprite_width * clamp(velocity.y, -1, 1)
	
	if(round(particle_node.position.x) == round(new_thrust_x) and round(particle_node.position.y) == round(new_thrust_y)):
		return
		
	particle_node.position.x = new_thrust_x
	particle_node.position.y = new_thrust_y
	var point = Vector2(position.x + (velocity.x * sprite_width), position.y + (velocity.y * sprite_width))
	particle_node.look_at(Vector2(position.x + (velocity.x * sprite_width * 4), position.y + (velocity.y * sprite_width * 4)))

# This is just a coin flip. I'll refactor the name when I feel like it isn't funny anymore
func flippity_flop():
	return rng.randi_range(0, 1) == 0
