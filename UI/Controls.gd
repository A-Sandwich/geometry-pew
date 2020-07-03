extends Node2D


var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	var controller = $UI/HBoxContainer/XboxController
	var wasd = $UI/HBoxContainer/VBoxContainer/WASD
	var arrows = $UI/HBoxContainer/VBoxContainer/Arrows
	screen_size = get_viewport_rect().size
	var size_constraint = screen_size.x / 2
	var controller_size = controller.get_rect().size
	var scale = size_constraint / controller_size.x
	controller.scale = Vector2(scale, scale)
	wasd.scale = Vector2(scale, scale)
	arrows.scale = Vector2(scale, scale)
	print(controller_size)
	controller.position = Vector2((controller_size.x * scale) / 2,  (controller_size.y * scale))
	wasd.position = Vector2(controller.position.x + ((wasd.get_rect().size.x * scale)), (wasd.get_rect().size.y * scale) / 2)
	arrows.position = Vector2(controller.position.x + ((arrows.get_rect().size.x * scale)), (arrows.get_rect().size.y * scale) + wasd.position.y)	
