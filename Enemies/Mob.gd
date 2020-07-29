extends Node2D

onready var COMMON = get_node("/root/Common")
onready var STAGE = get_node("/root/Stage")
onready var POWERUP = get_node("/root/Stage/PowerUpSelection/MarginContainer")
var WAVE = preload("res://Enemies/Wave.tscn")
onready var PLAYER = get_parent().get_node("Player")
var START_ENEMY_COUNT = 3

var screen_size
var spawn_limit = START_ENEMY_COUNT
var minimum_distance_from_player
var wave = WAVE.instance()
var corner_points = []
var wave_count = 1
signal wave_change(wave_count)

func _ready():
	ready()

func ready():
	wave.COMMON = COMMON
	wave.PLAYER = PLAYER
	screen_size = get_viewport_rect().size
	minimum_distance_from_player = screen_size.x / 6 #todo make ratios not dependent on screen.x (Ultrawide will make life not great)
	spawn_wave()
	wave.generate_wave()
	self.connect("wave_change", POWERUP, "on_wave_change")

func _process(delta):
	process(delta)

func any_enemies():
	return get_tree().get_nodes_in_group("Enemy").size() > 0

func process(delta):
	if not any_enemies():
		spawn_wave()
		$SpawnWave.start()

func random_map_point(player_position, sprite_width, min_distance = 25):
	var buffer = sprite_width / 2
	var x = COMMON.rng.randi_range(buffer, STAGE.stage_size.x - buffer)
	var y = COMMON.rng.randi_range(buffer, STAGE.stage_size.y - buffer)
	var location = Vector2(x, y)
	if (location.distance_to(player_position) >= min_distance):
		return location
	else:
		return random_map_point(player_position, sprite_width, min_distance)

# I should rename this. JK, refactoring sucks in the godot ide
func spawn_wave_jr():
	if len(wave.enemies) == 0:
		if $SpeedUpEnemies.is_stopped():
			$SpeedUpEnemies.start()
		return
	else:
		$SpeedUpEnemies.stop()
	var enemies = wave.enemies.pop_front()
	for enemy in enemies:
		enemy.position = random_map_point(PLAYER.position, 100)
		get_parent().add_child(enemy)

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
	
	if len(wave.enemies) < 1 and not any_enemies():
		wave_count += 1
		emit_signal("wave_change", wave_count)
		wave.generate_wave()
	else:
		spawn_wave_jr()

func _on_power_up():
	pass

func _on_SpeedUpEnemies_timeout():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.speed = enemy.speed * 1.5
	$SpeedUpEnemies.stop()
