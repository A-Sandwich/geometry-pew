extends Node2D

var screen_size
var ENEMY = preload("res://Enemies/Enemy.tscn")
var size = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if get_parent().get_tree().get_nodes_in_group("Enemy").size() < 3:
	if get_tree().get_nodes_in_group("Enemy").size() < 30:
		size += 1
		spawn_enemy()

func spawn_enemy():
	var enemy = ENEMY.instance()
	enemy.position.x = randf() * screen_size.x
	enemy.position.y = randf() * screen_size.y
	get_parent().add_child(enemy)

