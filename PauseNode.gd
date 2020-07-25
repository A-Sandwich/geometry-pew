extends Node2D

onready var POWERUP = get_node("/root/Stage/PowerUpSelection/MarginContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") and !POWERUP.visible:
		var is_paused = get_tree().paused
		get_tree().paused = not is_paused
