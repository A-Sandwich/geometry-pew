extends CanvasLayer

const DEFAULT_COLOR = Color(1, 1, 1, 0.8)
const HOVER_COLOR = Color(1, 1, 1, 1)
onready var COMMON = get_node("/root/Common")
onready var POWERUP = get_node("/root/Stage/PowerUpSelection/MarginContainer")
var screen_size
var is_paused = false
var ui_elements = []
var focus

func toggle_visible():
	$Menu.rect_position = Vector2((screen_size.x / 2) - ($Menu.rect_size.x / 2), screen_size.y / 4)
	$Menu.update()
	var geometry_points = PoolVector2Array()
	geometry_points = COMMON.get_square_points(geometry_points, screen_size.x)
	print("POWERUP "+str(!POWERUP.visible))
	if !POWERUP.visible:
		is_paused = not is_paused
		get_tree().paused = is_paused
	$Menu.visible = !$Menu.visible
	

func init(screen_size):
	self.screen_size = screen_size

func _ready():
	for child in $Menu.get_children():
		if child is Button:
			ui_elements.append(child)
			child.modulate = DEFAULT_COLOR

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_visible()
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

func on_entered(button):
	if focus != null and button != focus:
		on_exited(focus)
	focus = button
	button.modulate = HOVER_COLOR
	
func on_exited(button):
	button.modulate = DEFAULT_COLOR

func _on_Exit_pressed():
	get_tree().quit()

func _on_ExitMainMenu_pressed():
	print(get_tree().root.name)
	get_tree().change_scene("res://Title.tscn")
	get_tree().paused = false

func is_visible():
	return $Menu.visible


func _on_ExitMainMenu_mouse_entered():
	pass # Replace with function body.


func _on_ExitMainMenu_mouse_exited():
	pass # Replace with function body.


func _on_Exit_mouse_entered():
	pass # Replace with function body.


func _on_Exit_mouse_exited():
	pass # Replace with function body.
