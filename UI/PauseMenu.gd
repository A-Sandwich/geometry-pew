extends CanvasLayer

onready var COMMON = get_node("/root/Common")
onready var POWERUP = get_node("/root/Stage/PowerUpSelection/MarginContainer")
var screen_size
var is_paused = false

func toggle_visible():
	$Menu.rect_position = Vector2((screen_size.x / 2) - ($Menu.rect_size.x / 2), screen_size.y / 4)
	$Menu.update()
	var geometry_points = PoolVector2Array()
	geometry_points = COMMON.get_square_points(geometry_points, screen_size.x)
	print("POWERUP "+str(!POWERUP.visible))
	if !POWERUP.visible:
		is_paused = not is_paused
		get_tree().paused = is_paused
		print("Toggling")
	else:
		print("Not toggling")
	$Menu.visible = !$Menu.visible

func init(screen_size):
	self.screen_size = screen_size

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_visible()

func _on_Exit_pressed():
	get_tree().quit()

func _on_ExitMainMenu_pressed():
	print(get_tree().root.name)
	get_tree().change_scene("res://Title.tscn")
	get_tree().paused = false

func is_visible():
	return $Menu.visible
