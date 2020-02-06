extends Node

const DEFAULT_TIMER_LENGTH = 0.75

func _ready():
	pass # Replace with function body.

func setup(position, text, timeout = DEFAULT_TIMER_LENGTH):
	$TextToFade.set_global_position(position)
	$TextToFade.text = text
	$TextToFade.visible = true
	$TimeLeftToLive.wait_time = timeout
	$TimeLeftToLive.start()

func _on_TimeLeftToLive_timeout():
	$TimeLeftToLive.stop()
	self.queue_free()
