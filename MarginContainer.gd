extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_StartGame_pressed():
	get_tree().change_scene("res://Stage.tscn")


func _on_Exit_pressed():
	get_tree().quit()