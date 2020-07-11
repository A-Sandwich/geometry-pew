extends Node

var rng = RandomNumberGenerator.new()
var screen_size
var EXPLOSION = preload("res://Effects/fake_explosion_particles.tscn")

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
		var visible_rect = node.get_viewport().get_visible_rect()
		screen_size = visible_rect.end
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

# I think I need to roll my own explosion particle. Seems to cause frame drops
func generate_explosion(position):
		var explosion = EXPLOSION.instance()
		explosion.position = position
		return explosion

func save_high_score(json):
	print("saving...")
	json.sort_custom(self, "sort_descending")
	var file = File.new()
	file.open("user://high_scores.dat", File.WRITE)
	file.store_string(JSON.print(json.slice(0, 9)))
	file.close()

static func sort_descending(a, b):
		if a['score'] > b['score']:
			return true
		return false

func load_high_score(existing_data):
	if existing_data != null:
		return existing_data
	var file = File.new()
	file.open("user://high_scores.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse(content)
	if result.get_error() != 0:
		print("Error: " + str(file.get_error()) + ", " + file.get_error_string())
		return []
	return result.get_result()



