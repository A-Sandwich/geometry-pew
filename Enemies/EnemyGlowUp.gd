extends Area2D

var enemy
onready var COMMON = get_node("/root/Common")
var color = Color(.03, 0.5, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# The goal of this is for it to show an enemy is spawning, and after spawn we want the particle
# to fade out and then remove it's self from the tree.
