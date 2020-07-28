extends Node

var rng = RandomNumberGenerator.new()
var screen_size
var infinite_lives = false
var black_and_white = false
var EXPLOSION = preload("res://Effects/Explosion.tscn")
onready var AUDIO = get_node("/root/Audio")
var DEFAULT_RESOLUTION = Vector2(1920, 1080)

func _ready():
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
func generate_explosion(position, hits_left = -1):
	var explosion = EXPLOSION.instance()
	explosion.position = position
	if hits_left > -1:
		var factor = (15 - hits_left) * 0.1
		explosion.find_node("AudioStreamPlayer2D").pitch_scale = 1 + factor
	get_parent().add_child(explosion)

func save_high_score(json):
	print("saving highscore...")
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

func get_player_width(node):
	return get_screen_size(node).y / 100

func save_settings(json):
	print("saving settings...")
	var file = File.new()
	file.open("user://settings.dat", File.WRITE)
	file.store_string(JSON.print(json))
	file.close()

func load_settings():
	var file = File.new()
	file.open("user://settings.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse(content)
	if result.get_error() != 0:
		print("Error: " + str(file.get_error()))
		return null
	return result.get_result()

func apply_volume(volume):
	AUDIO.volume_db = (volume / 100) * -.80

func apply_resolution(resolution):
	print("RESOLUTION")
	print(str(resolution))
	var current_resolution = get_tree().root.get_viewport().size
	print(str(current_resolution))
	if current_resolution != resolution:
		OS.set_window_size(resolution)
		get_tree().root.get_viewport().set_size(resolution);
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_EXPAND, resolution);
		screen_size = resolution

func string_resolution_to_vector(string_resolution):
	if string_resolution == null:
		return DEFAULT_RESOLUTION
	var resolution_parts = string_resolution.split(", ")
	if len(resolution_parts) < 2:
		return DEFAULT_RESOLUTION
	return Vector2(int(resolution_parts[0]), int(resolution_parts[1]))
	
	
