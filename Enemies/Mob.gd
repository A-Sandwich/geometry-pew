extends Node2D

onready var COMMON = get_node("/root/Common")
onready var PLAYER = get_parent().get_node("Player")

var ENEMY = preload("res://Enemies/Enemy.tscn")
var DISK_ENEMY = preload("res://Enemies/DiskEnemy.tscn")
var START_ENEMY_COUNT = 3

var screen_size
var spawn_enemies = true
var spawn_limit = START_ENEMY_COUNT
var minimum_distance_from_player
var wave = []
var wave_timeout = 10

# waves probably need to be abstracted out into their own class so we can layer waves together.

# Called when the node enters the scene tree for the first time.
func _ready():
	ready()

func ready():
	screen_size = get_viewport_rect().size
	minimum_distance_from_player = screen_size.x / 6 #todo make ratios not dependent on screen.x (Ultrawide will make life not great)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process(delta)
	
func process(delta):
	if !spawn_enemies:
		return

func spawn_enemy():
	var stage_size = get_parent().stage_size
	var enemy = choose_enemy().instance()
	var spawn_location = Vector2(get_valid_point(screen_size.x, PLAYER.position.x),  get_valid_point(screen_size.y, PLAYER.position.y))
	
	enemy.position = spawn_location
	enemy.PLAYER = PLAYER
	enemy.speed = COMMON.rng.randi_range(enemy.speed_range.x, enemy.speed_range.y)
	
	get_parent().add_child(enemy)
	spawn_enemies = false
	$SpawnRate.start()

func choose_enemy():
	if (COMMON.rng.randi_range(0, 1) == 0):
		return ENEMY
	else:
		return DISK_ENEMY

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
	var enemies = wave.pop_front()
	
	for enemy in enemies:
		enemy.position = spawn_location
		get_parent().add_child(enemy)

# Goal: generate a stack of enemies that slowly get larger to crachendo 
func generate_wave():
	wave.clear()
	var minimum = 3
	var enemy = choose_enemy()
	# generate a stack that we can just pop each time we spawn a wave
	for i in range(COMMON.rng.randi_range(3, 10)):
		var inner_wave = []
		for j in range(COMMON.rng.randi_range(minimum, minimum * 2)):
			var new_enemy = enemy.instance()
			new_enemy.PLAYER = PLAYER
			new_enemy.speed = COMMON.rng.randi_range(new_enemy.speed_range.x, new_enemy.speed_range.y)
			inner_wave.append(new_enemy)
		minimum += 1
		wave.append(inner_wave)

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
	if len(wave) < 1:
		generate_wave()
	else:
		spawn_wave_jr()
