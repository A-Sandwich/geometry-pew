extends Node

const MULTIPLIER_BASE = 1000
const MULTIPLIER_THRESHOLDS = [
	1 * MULTIPLIER_BASE,
	2 * MULTIPLIER_BASE + MULTIPLIER_BASE,
	3 * MULTIPLIER_BASE + 2 * MULTIPLIER_BASE + MULTIPLIER_BASE,
	5 * MULTIPLIER_BASE + 3 * MULTIPLIER_BASE + 2 * MULTIPLIER_BASE + MULTIPLIER_BASE
]
const THRESHOLD_TIMES = [10, 7, 5, 4, 3]
const MULTIPLIER_DEGREDATION_AMOUNT = 100

var multiplier = 1
var meter = 0
var multiplier_index = 0

signal multiplier_changed

func _ready():
	self.connect("multiplier_changed", get_parent().get_node("HUD"), "_on_multiplier_changed")

func reset():
	multiplier = 1
	meter = 0
	multiplier_index = 0
	emit_multiplier_change()

func stop_multiplier_degredation():
	$MultiplierDegredationRate.stop()
	$TimeToDiminish.stop()

func on_enemy_destroyed(enemy, player):
	stop_multiplier_degredation()
	increment_meter(enemy)
	$TimeToDiminish.wait_time = THRESHOLD_TIMES[multiplier_index]
	$TimeToDiminish.start()

func get_multiplier():
	return multiplier_index + 1

func increment_meter(enemy):
	meter += enemy.point_value
	if meter > MULTIPLIER_THRESHOLDS[multiplier_index]:
		multiplier_index = clamp (multiplier_index + 1, 0, len(MULTIPLIER_THRESHOLDS) - 1)
	emit_multiplier_change()

func decrement_meter():
	if meter <= 0:
		meter = 0
		return
	
	if len(get_tree().get_nodes_in_group("Enemy")) == 0:
		return

	meter -= MULTIPLIER_DEGREDATION_AMOUNT
	var potential_multiplier_index = clamp (multiplier_index - 1, 0, len(MULTIPLIER_THRESHOLDS) - 1)
	if meter <= MULTIPLIER_THRESHOLDS[potential_multiplier_index]:
		multiplier_index = potential_multiplier_index
	emit_multiplier_change()

func emit_multiplier_change():
	var previous_threshold = 0
	if multiplier_index > 0:
		previous_threshold = MULTIPLIER_THRESHOLDS[multiplier_index - 1]
	emit_signal("multiplier_changed", get_multiplier(), meter - previous_threshold, MULTIPLIER_THRESHOLDS[multiplier_index])

func _on_TimeToDiminish_timeout():
	$TimeToDiminish.stop() # Do I need to call stop() ?
	$MultiplierDegredationRate.start()

func _on_MultiplierDegredationRate_timeout():
	decrement_meter()
	if meter > 0:
		$MultiplierDegredationRate.start() # Do I need to call start again?
