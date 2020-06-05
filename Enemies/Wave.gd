extends Node

onready var PLAYER = get_parent().get_node("Player")
var COMMON 
var ENEMY = preload("res://Enemies/Enemy.tscn")
var DISK_ENEMY = preload("res://Enemies/DiskEnemy.tscn")
var TINY_CUBE_ENEMY = preload("res://Enemies/TinyCubeEnemy.tscn")
var SHOOTING_ENEMY = preload("res://Enemies/ShootingEnemy.tscn")
var ENEMY_GLOW_UP = preload("res://Enemies/EnemyGlowUp.tscn")
var enemy_classes = [ENEMY, DISK_ENEMY, TINY_CUBE_ENEMY, SHOOTING_ENEMY]


var minimum_distance_from_player
var screen_size
var enemies = []
var speed_increase = 0.2
var speed_multiplier = 1
var wave_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ready()
func ready():
	generate_wave()
	minimum_distance_from_player = screen_size.x / 6 #todo make ratios not dependent on screen.x (Ultrawide will make life not great)

func choose_enemy():
	var index = COMMON.rng.randi_range(0, len(enemy_classes) - 1)
	return enemy_classes[index]

func generate_wave():
	wave_count += 1
	enemies.clear()
	var minimum = 3
	
	# generate a stack that we can just pop each time we spawn a wave
	for i in range(COMMON.rng.randi_range(3, 10)):
		var inner_enemies = []
		var enemy = choose_enemy()
		for j in range(COMMON.rng.randi_range(minimum, minimum * 2)):
			var new_enemy = enemy.instance()
			new_enemy.PLAYER = PLAYER
			new_enemy.speed = COMMON.rng.randi_range(new_enemy.speed_range.x,
				new_enemy.speed_range.y)  * speed_multiplier 
			var spawn_container = ENEMY_GLOW_UP.instance()
			spawn_container.enemy = new_enemy
			inner_enemies.append(spawn_container)
		minimum += 1
		enemies.append(inner_enemies)
	speed_multiplier += speed_increase # I assume I'll want to make a max for this eventually
