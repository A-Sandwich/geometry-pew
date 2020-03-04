extends ProgressBar

export var final_val = 0
var previous_delta = 0
var UPDATE_INTERVAL = 0.025
var step_amount = 1

func _ready():
	value = 0
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var updateUi = final_val != value
	var update_interval_exceeded = previous_delta > UPDATE_INTERVAL
	if final_val > value and update_interval_exceeded:
		previous_delta = 0
		value = clamp(value + step_amount, value, final_val)
	elif final_val < value and update_interval_exceeded:
		previous_delta = 0
		value = clamp(value - step_amount, final_val, value)
	elif previous_delta < UPDATE_INTERVAL:
		previous_delta += delta
	if updateUi and update_interval_exceeded:
		print("Value ",value)
		update()

func rollover():
	value = 0
	update()
