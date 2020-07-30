extends Node2D

onready var COMMON = get_node("/root/Common")

func _ready():
	$Particles2D.emitting = true
	if COMMON.black_and_white:
		$Particles2D.process_material.color_ramp.gradient.colors = [Color(1,1,1,1)]
		$Particles2D.process_material.hue_variation = 0
		$Particles2D.process_material.hue_variation_random = 0
	$AudioStreamPlayer2D.volume_db = get_node("/root/Audio").volume_db

func _process(delta):
	if !$Particles2D.emitting:
		print("Freeing")
		queue_free()
