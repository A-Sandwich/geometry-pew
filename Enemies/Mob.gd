extends Node2D

onready var COMMON = get_node("/root/Common")
var WAVE = preload("res://Enemies/Wave.tscn")
onready var PLAYER = get_parent().get_node("Player")
var START_ENEMY_COUNT = 3

var screen_size
var spawn_enemies = true
var spawn_limit = START_ENEMY_COUNT
var minimum_distance_from_player
var wave = WAVE.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	ready()

func ready():
	wave.COMMON = COMMON
	wave.PLAYER = PLAYER
	screen_size = get_viewport_rect().size
	minimum_distance_from_player = screen_size.x / 6 #todo make ratios not dependent on screen.x (Ultrawide will make life not great)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process(delta)
	
func process(delta):
	if !spawn_enemies:
		return

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
	var enemies = wave.enemies  .pop_front()
	
	for enemy in enemies:
		enemy.position = spawn_location
		get_parent().add_child(enemy)

# Goal: generate a stack of enemies that slowly get larger to crescendo

func reset():
	spawn_enemies = false
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()

func start():
	spawn_limit = START_ENEMY_COUNT
	spawn_enemies = true

func _on_SpawnRate_timeout():
	spawn_enemies = true
	$SpawnRate.stop()

func _on_IncreaseSpawnLimit_timeout():
	spawn_limit += 1

func _on_SpawnWave_timeout():
	if len(wave.enemies) < 1:
		wave.generate_wave()
	else:
		spawn_wave_jr()
