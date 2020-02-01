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

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	minimum_distance_from_player = screen_size.x / 6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !spawn_enemies:
		return
	if get_tree().get_nodes_in_group("Enemy").size() < spawn_limit:
		spawn_enemy()

func spawn_enemy():
	var stage_size = get_parent().stage_size
	var enemy = null
	if (COMMON.rng.randi_range(0, 1) == 0):
		enemy = ENEMY.instance()
	else:
		enemy = DISK_ENEMY.instance()
	var spawn_location = Vector2(get_valid_point(screen_size.x, PLAYER.position.x),  get_valid_point(screen_size.y, PLAYER.position.y))
	
	enemy.position = spawn_location
	enemy.PLAYER = PLAYER
	enemy.speed = COMMON.rng.randi_range(enemy.speed_range.x, enemy.speed_range.y)
	
	get_parent().add_child(enemy)
	spawn_enemies = false
	$SpawnRate.start()

func get_valid_point(upper_bound, player_point):
	var point = 0
	var finding_point = true
	
	while(finding_point):
		point = COMMON.rng.randi_range(0, upper_bound)
		if point < (player_point - minimum_distance_from_player) or point > (player_point + minimum_distance_from_player):
			finding_point = false
	
	return point
	
func _on_IncreaseSpawnLimit_timeout():
	spawn_limit += 1

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
