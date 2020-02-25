extends MarginContainer

onready var COMMON = get_node("/root/Common")

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = self.get_viewport_rect().size
	var keepMargines = false
	var player = $VBoxContainer/Player
	$VBoxContainer/Player/ThrustParticleFast.visible = false
	COMMON.thrust($VBoxContainer/Player/ThrustParticle, Vector2(1,0), player.sprite_width, player.position)

func _on_StartGame_pressed():
	get_tree().change_scene("res://Stage.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Start_pressed():
	get_tree().change_scene("res://Stage.tscn")
