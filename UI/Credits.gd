extends MarginContainer
onready var size = get_viewport().get_visible_rect().size

func _ready():
	rect_size.x = size.x
	margin_top = size.y / 5

func _on_GoBack_pressed():
	get_tree().change_scene("res://Title.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$VBoxContainer/GoBack.emit_signal("pressed")
