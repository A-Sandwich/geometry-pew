extends MarginContainer
onready var size = get_viewport().get_visible_rect().size

func _ready():
	rect_size.x = size.x
	margin_top = size.y / 5
