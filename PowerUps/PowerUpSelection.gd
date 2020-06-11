extends Node
var MOB


func _ready():
	print("Ready")
	MOB =  get_parent().get_node("Mob")
	MOB.connect("wave_change", self, "on_wave_change")
	$Selection.visible = false

func on_wave_change(wave_count):
	print("IN POWER UP SELECTION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	$Selection.visible = true
	#if wave_count % 5 == 0:
	get_tree().paused = true


func _on_OptionOne_pressed():
	get_tree().paused = false
	$Selection.visible = false
