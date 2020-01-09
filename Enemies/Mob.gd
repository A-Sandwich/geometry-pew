extends Node2D

var screen_size
var ENEMY = preload("res://Enemies/Enemy.tscn")
var size = 0
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if get_parent().get_tree().get_nodes_in_group("Enemy").size() < 3:
	if get_tree().get_nodes_in_group("Enemy").size() < 30:
		size += 1
		spawn_enemy()

func spawn_enemy():
	var enemy = ENEMY.instance()
	if rng.randi_range(1, 2) == 2:
		enemy.position.x = screen_size.x + 200
		enemy.position.y = rng.randi_range(0, screen_size.y)
	else:
		enemy.position.x = rng.randi_range(0, screen_size.x)
		enemy.position.y = screen_size.y + 200
	get_parent().add_child(enemy)

