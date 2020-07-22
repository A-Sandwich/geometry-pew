extends MarginContainer
var MOB
var PLAYER
const POWER_UP_OPTIONS = ["shrink_ship", "increase_bullet_size", "extra_bomb", "longer_boost"]
signal power_up(power)
var debugging = true
var column_width
onready var option_one_image = $VBoxContainer/Selection/OptionOne/OptionOneImage
onready var option_two_image = $VBoxContainer/Selection/OptionTwo/OptionTwoImage

func _ready():
	set_visibility(false)
	MOB =  get_parent().get_node("Mob")
	PLAYER =  get_parent().get_node("Player")
	MOB.connect("wave_change", self, "on_wave_change")
	$VBoxContainer.visible = false
	self.connect("power_up", PLAYER, "on_power_up")
	var width = ($VBoxContainer/Selection/OptionOne.rect_size.x +
		$VBoxContainer/Selection/OptionTwo.rect_size.x)
	width = width if width > $VBoxContainer.rect_size.x else  $VBoxContainer.rect_size.x
	column_width = PLAYER.screen_size.x / 4 if PLAYER.screen_size.x / 5  < 500 else 500
	print("Size: " + str(width))
	#update_options()
	rect_position = Vector2(PLAYER.screen_size.x / 2, PLAYER.screen_size.y / 2)

func update_options():
	print("COLUMN WIDTH " + str(column_width))
	var scale = column_width / option_one_image.rect_size.x
	var size = option_one_image.get_rect().size
	#option_one_image.set_size(Vector2(size.x * scale, size.y * scale), true)
	option_one_image.rect_scale = Vector2(size.x * scale, size.y * scale)
	option_one_image.update()
	print("scale :" + str(scale))
	print("Size :" + str(option_one_image.rect_size))
	
	scale = column_width / option_two_image.rect_size.x
	size = option_two_image.rect_size
	option_two_image.rect_size = Vector2(size.x * scale, size.y * scale)
	option_two_image.update()

func _process(delta):
	if Input.is_action_just_pressed("power_up"):
		on_wave_change(1)

func on_wave_change(wave_count):
	if wave_count % 2 == 0 or debugging:
		randomize_selection()
		set_visibility(true)
		get_tree().paused = true

func randomize_selection():
	var randomized_power_ups = []
	var now_youre_playing_with_power = POWER_UP_OPTIONS.duplicate()
	var size = now_youre_playing_with_power.size()
	for outer_index in  range(size):
		var index = randi()%now_youre_playing_with_power.size()
		var selection = now_youre_playing_with_power[index]
		randomized_power_ups.append(
			 selection
		)
		now_youre_playing_with_power.erase(selection)
	#for index in range($VBoxContainer/Selection.get_child_count()):
	#	$VBoxContainer/Selection.get_child(index).text = randomized_power_ups[index]


func _on_OptionOne_pressed():
	emit_power_up($VBoxContainer/Selection/OptionOne.text)


func _on_OptionTwo_pressed():
	emit_power_up($VBoxContainer/Selection/OptionTwo.text)
	
func set_visibility(is_visible):
	$VBoxContainer.visible = is_visible
	$Background.visible = is_visible
	$VBoxContainer/Select.visible = is_visible
	
func emit_power_up(type):
	get_tree().paused = false
	set_visibility(false)
	emit_signal("power_up", type.replace("_", " "))
