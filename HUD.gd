extends Node

# Declare member variables here. Examples:
# var a = 2
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("bullet_destroyed_enemy", self, "on_enemy_destroyed")

func on_enemy_destroyed(enemy, player):
	score += enemy.point_value
