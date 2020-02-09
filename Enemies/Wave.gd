extends Node

onready var PLAYER = get_parent().get_node("Player")
var COMMON 
var ENEMY = preload("res://Enemies/Enemy.tscn")
var DISK_ENEMY = preload("res://Enemies/DiskEnemy.tscn")

var minimum_distance_from_player
var screen_size
var wave = []

# Called when the node enters the scene tree for the first time.
func _ready():
	ready()
func ready():
	generate_wave()
	minimum_distance_from_player = screen_size.x / 6 #todo make ratios not dependent on screen.x (Ultrawide will make life not great)

func choose_enemy():
	if (COMMON.rng.randi_range(0, 1) == 0):
		return ENEMY
	else:
		return DISK_ENEMY
		
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
