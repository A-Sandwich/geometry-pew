extends Node2D

onready var COMMON = get_node("/root/Common")
onready var STAGE = get_node("/root/Stage")
var WAVE = preload("res://Enemies/Wave.tscn")
onready var PLAYER = get_parent().get_node("Player")
var START_ENEMY_COUNT = 3

var screen_size
var spawn_limit = START_ENEMY_COUNT
var minimum_distance_from_player
var wave = WAVE.instance()
var corner_points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	ready()

func ready():
	wave.COMMON = COMMON
	wave.PLAYER = PLAYER
	screen_size = get_viewport_rect().size
	minimum_distance_from_player = screen_size.x / 6 #todo make ratios not dependent on screen.x (Ultrawide will make life not great)
	generate_corner_spawn_points()
	spawn_wave()

func generate_corner_spawn_points():
	var spacing = STAGE.stage_size.x / 8
	corner_points = [Vector2(spacing, spacing), Vector2(spacing, STAGE.stage_size.y - spacing),
	Vector2(STAGE.stage_size.x - spacing, STAGE.stage_size.y - spacing),
	Vector2(STAGE.stage_size.x - spacing, spacing)]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process(delta)
	
func process(delta):
	pass

func get_valid_point(upper_bound, player_point):
	var point = 0
	var finding_point = true
	
	while(finding_point):
		point = COMMON.rng.randi_range(0, upper_bound)
		if point < (player_point - minimum_distance_from_player) or point > (player_point + minimum_distance_from_player):
			finding_point = false
	return point

# I should rename this
func spawn_wave_jr():
	var spawn_location = Vector2(get_valid_point(screen_size.x, PLAYER.position.x),
		get_valid_point(screen_size.y, PLAYER.position.y))
	var enemies = wave.enemies.pop_front()

	for enemy in enemies:
		enemy.position = corner_points.pop_front()
		corner_points.append(enemy.position)
		get_parent().add_child(enemy)

func reset():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()

func start():
	spawn_limit = START_ENEMY_COUNT

func _on_SpawnRate_timeout():
	$SpawnRate.stop()

func _on_IncreaseSpawnLimit_timeout():
	spawn_limit += 1

func _on_SpawnWave_timeout():
	spawn_wave()
	
func spawn_wave():
	if PLAYER.dead:
		return
	
	if len(wave.enemies) < 1:
		wave.generate_wave()
	else:
		spawn_wave_jr()
