extends Node
var MOB
var PLAYER
const POWER_UP_OPTIONS = ["shrink", "big_pew", "extra_bomb"]
signal power_up(power)
var debugging = false

func _ready():
	print("Ready")
	MOB =  get_parent().get_node("Mob")
	PLAYER =  get_parent().get_node("Player")
	MOB.connect("wave_change", self, "on_wave_change")
	$Selection.visible = false
	self.connect("power_up", PLAYER, "on_power_up")

func _process(delta):
	if Input.is_action_just_pressed("power_up"):
		debugging = true
		on_wave_change(1)

func on_wave_change(wave_count):
	if wave_count % 5 == 0 or debugging:
		debugging = false
		randomize_selection()
		$Selection.visible = true
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
	for index in range($Selection.get_child_count()):
		$Selection.get_child(index).text = randomized_power_ups[index]


func _on_OptionOne_pressed():
	emit_power_up($Selection/OptionOne.text)


func _on_OptionTwo_pressed():
	emit_power_up($Selection/OptionTwo.text)
	
func emit_power_up(type):
	get_tree().paused = false
	$Selection.visible = false
	emit_signal("power_up", type.replace("_", " "))
