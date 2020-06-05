extends Area2D

var enemy
onready var COMMON = get_node("/root/Common")
var color = Color(.03, 0.5, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	ready()

func ready():
	add_to_group("Enemy") # If we don't add the spawn container to this group, then we'll infinitely spawn
	color = enemy.color
	$Particles2D.process_material.color = color
	enemy.position = position
	$TimeToSpawn.start()
	
	



func _on_TimeToSpawn_timeout():
	get_parent().add_child(enemy)
	self.queue_free()
