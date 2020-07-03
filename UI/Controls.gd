extends Node2D


var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	var controller = $UI/HBoxContainer/XboxController
	screen_size = get_viewport_rect().size
	var size_constraint = screen_size.x / 2
	var controller_size = controller.get_rect().size
	var scale = size_constraint / controller_size.x
	controller.scale = Vector2(scale, scale)
	print(controller_size)
	controller.position = Vector2((controller_size.x * scale) / 2,  (controller_size.y * scale))
	print(controller.position)
	
