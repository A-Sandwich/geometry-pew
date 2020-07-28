extends MarginContainer

onready var COMMON = get_node("/root/Common")
var screen_size
const DEFAULT_COLOR = Color(1, 1, 1, 0.8)
const HOVER_COLOR = Color(1, 1, 1, 1)
var focus
var ui_elements = []

func _ready():
	var player = $VBoxContainer/Player
	player.update()
	player.screen_size = Common.get_screen_size(player)
	print("PLAYER SCREEN SIZE " +str(player.screen_size))
	COMMON.thrust($VBoxContainer/Player/ThrustParticle, Vector2(1,0), player.sprite_width, player.position)
	screen_size = player.screen_size
	rect_size = screen_size
	setup_buttons()
	var ui_height = $VBoxContainer/Start.rect_size.y * 4	
	$CanvasLayer/Version.rect_position = Vector2(0, screen_size.y - $CanvasLayer/Version.rect_size.y)
	focus = ui_elements[0]
	focus.emit_signal("mouse_entered")
	update()

func _process(delta):
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_focus_prev"):
		var index = ui_elements.find(focus)
		if index <= 0:
			pass
		else:
			on_entered(ui_elements[index - 1])
	elif Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_focus_next"):
		var index = ui_elements.find(focus)
		if index == -1:
			on_entered(ui_elements[0])
		elif index == (len(ui_elements) - 1):
			pass
		else:
			on_entered(ui_elements[index + 1])
	elif Input.is_action_just_pressed("ui_accept"):
		if focus != null:
			focus.emit_signal("pressed")

func setup_buttons():
	position_particle($VBoxContainer/Start/StartParticle, $VBoxContainer/Start)
	position_particle($VBoxContainer/Options/OptionsParticle, $VBoxContainer/Options)
	position_particle($VBoxContainer/Credits/CreditsParticle, $VBoxContainer/Credits)
	position_particle($VBoxContainer/Exit/ExitParticle, $VBoxContainer/Exit)
	for child in $VBoxContainer.get_children():
		if child is Button:
			child.modulate = DEFAULT_COLOR
			ui_elements.append(child)
func position_particle(particle, parent):
	var particle_position = Vector2(screen_size.x/2, parent.rect_size.y / 2)
	particle.position = particle_position
	particle.update()

func on_entered(button):
	if focus != null and button != focus:
		on_exited(focus)
	focus = button
	button.modulate = HOVER_COLOR
	button.get_children()[0].emitting = true
	
func on_exited(button):
	button.modulate = DEFAULT_COLOR
	button.get_children()[0].emitting = false

func _on_StartGame_pressed():
	get_tree().change_scene("res://Stage.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Start_pressed():
	get_tree().change_scene("res://UI/Controls.tscn")


func _on_Start_mouse_entered():
	on_entered($VBoxContainer/Start)


func _on_Start_mouse_exited():
	on_exited($VBoxContainer/Start)


func _on_Exit_mouse_entered():
	on_entered($VBoxContainer/Exit)


func _on_Exit_mouse_exited():
	on_exited($VBoxContainer/Exit)


func _on_Options_pressed():
	get_tree().change_scene("res://UI/Options.tscn")


func _on_Options_mouse_entered():
	on_entered($VBoxContainer/Options)


func _on_Options_mouse_exited():
	on_exited($VBoxContainer/Options)


func _on_Credits_pressed():
	get_tree().change_scene("res://UI/Credits.tscn")


func _on_Credits_mouse_entered():
	on_entered($VBoxContainer/Credits)


func _on_Credits_mouse_exited():
	on_exited($VBoxContainer/Credits)
