extends Node
var MOB
var PLAYER
var power_up_options = []
signal power_up(power)

func _ready():
	print("Ready")
	MOB =  get_parent().get_node("Mob")
	PLAYER =  get_parent().get_node("Player")
	MOB.connect("wave_change", self, "on_wave_change")
	$Selection.visible = false
	self.connect("power_up", PLAYER, "on_power_up")

func on_wave_change(wave_count):
	randomize_selection()
	update_selection()
	$Selection.visible = true
	#if wave_count % 5 == 0:
	get_tree().paused = true

func randomize_selection():
	power_up_options.clear()
	power_up_options.append("Shrink")

func update_selection():
	for index in $Selection.get_child_count():
		$Selection.get_child(index).text = power_up_options[index]



func _on_OptionOne_pressed():
	get_tree().paused = false
	$Selection.visible = false
	var power_up_type = "smol"
	emit_signal("power_up", power_up_type)
