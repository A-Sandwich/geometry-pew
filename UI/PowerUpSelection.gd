extends MarginContainer
onready var option_one_texture = $VBoxContainer/HBoxContainer/OptionOne/TextureRect
onready var option_two_texture = $VBoxContainer/HBoxContainer/OptionTwo/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = get_viewport().get_visible_rect().size
	update_texture_size(option_one_texture, size.x / 4)
	update_texture_size(option_two_texture, size.x / 4)

func update_texture_size(texture, size):
	texture.rect_min_size = Vector2(size, size)
	texture.update()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
