extends MarginContainer

onready var COMMON = get_node("/root/Common")
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = $VBoxContainer/Player
	player.screen_size = Common.get_screen_size(player)
	COMMON.thrust($VBoxContainer/Player/ThrustParticle, Vector2(1,0), player.sprite_width, player.position)
	screen_size = player.screen_size
	rect_size = screen_size
	position_particle($VBoxContainer/Start/StartParticle, $VBoxContainer/Start)
	position_particle($VBoxContainer/Options/OptionsParticle, $VBoxContainer/Options)
	position_particle($VBoxContainer/Credits/CreditsParticle, $VBoxContainer/Credits)
	position_particle($VBoxContainer/Exit/ExitParticle, $VBoxContainer/Exit)
	var ui_height = $VBoxContainer/Start.rect_size.y * 4	
	$CanvasLayer/Version.rect_position = Vector2(0, screen_size.y - $CanvasLayer/Version.rect_size.y)
	update()

func position_particle(particle, parent):
	var particle_position = Vector2(screen_size.x/2, parent.rect_size.y / 2)
	particle.position = particle_position
	particle.update()

func _on_StartGame_pressed():
	get_tree().change_scene("res://Stage.tscn")

func _on_Exit_pressed():
	print("Exit")
	get_tree().quit()

func _on_Start_pressed():
	get_tree().change_scene("res://UI/Controls.tscn")


func _on_Start_mouse_entered():
	$VBoxContainer/Start/StartParticle.emitting = true


func _on_Start_mouse_exited():
	$VBoxContainer/Start/StartParticle.emitting = false


func _on_Exit_mouse_entered():
	$VBoxContainer/Exit/ExitParticle.emitting = true


func _on_Exit_mouse_exited():
	$VBoxContainer/Exit/ExitParticle.emitting = false


func _on_Options_pressed():
	get_tree().change_scene("res://UI/Options.tscn")


func _on_Options_mouse_entered():
	$VBoxContainer/Options/OptionsParticle.emitting = true


func _on_Options_mouse_exited():
	$VBoxContainer/Options/OptionsParticle.emitting = false


func _on_Credits_pressed():
	get_tree().change_scene("res://UI/Credits.tscn")


func _on_Credits_mouse_entered():
	$VBoxContainer/Credits/CreditsParticle.emitting = true


func _on_Credits_mouse_exited():
	$VBoxContainer/Credits/CreditsParticle.emitting = false
