extends Node2D

onready var COMMON = get_node("/root/Common")

var ENEMY = preload("res://Enemies/Enemy.tscn")

var screen_size
var size = 0
var spawn_points = [Vector2(100, 100), Vector2(1000, 1000), Vector2(100, 1000), Vector2(1000, 100)]
var spawn_enemies = true
var spawn_limit = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !spawn_enemies:
		return
	#if get_parent().get_tree().get_nodes_in_group("Enemy").size() < 3:
	if get_tree().get_nodes_in_group("Enemy").size() < spawn_limit:
		size += 1
		spawn_enemy()

func spawn_enemy():
	var stage_size = get_parent().stage_size
	var enemy = ENEMY.instance()
	var spawn_location = COMMON.rng.randi_range(0,3)
	enemy.position = spawn_points[spawn_location]
	enemy.speed = COMMON.rng.randi_range(enemy.speed_range.x, enemy.speed_range.y)
	get_parent().add_child(enemy)



func _on_IncreaseSpawnLimit_timeout():
	spawn_limit += 1
