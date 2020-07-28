extends Node2D

func _ready():
	$Particles2D.emitting = true

func _process(delta):
	if !$Particles2D.emitting:
		print("Freeing")
		self.queue_free()
