extends Area2D

onready var COMMON = get_node("/root/Common")
onready var HUD = get_parent().get_node("HUD")
onready var SCORE_MULTIPLIER = get_parent().get_node("ScoreMultiplier")
onready var STAGE = get_node("/root/Stage")
var FADING_TEXT = preload("res://Effects/FadingText.tscn")
var PLAYER
var stage_size
signal bullet_destroyed_enemy

var color = Color("DB2F2F")
var motion = Vector2(0, 0)
var pace_direction_x = 1
var player_position
var point_value = 100
var speed = 200
var speed_range = Vector2(50, 225)
var sprite_width
var requires_multiple_hits = false
var extra_hits = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	if PLAYER != null:
		PLAYER.connect("bomb_detonated", self, "on_bomb_detonated")
	add_to_group("Enemy")
	self.connect("bullet_destroyed_enemy", HUD, "on_enemy_destroyed")
	self.connect("bullet_destroyed_enemy", SCORE_MULTIPLIER, "on_enemy_destroyed")
	self.connect("area_entered", self, "_on_area_entered")
	sprite_width = COMMON.get_screen_size(self).x / 100
	player_position = COMMON.get_screen_size(self) / 2
	stage_size = STAGE.stage_size
	if scale.x > 1:
		requires_multiple_hits = true
		point_value *= extra_hits
	ready()

func ready():
	print("ready not implemented")
	push_error("Not implemented")

func _process(delta):
	player_position = PLAYER.position
	process(delta)
	
func process(delta):
	if !PLAYER.dead:
		move(delta)
	else:
		$ThrustParticle.emitting = false
		
func get_direction_towards_player():
	return (player_position - position).normalized()

func move(delta):
	var velocity = Vector2()  # The enemy's movement vector.
	velocity = get_direction_towards_player() * speed
	position += velocity * delta
	
	var stage_size = get_parent().stage_size
	if (position.x < -sprite_width or position.x > stage_size.x + sprite_width or
		position.y < -sprite_width or position.y > stage_size.y + sprite_width):
		visible = false
	else:
		visible = true
	COMMON.thrust($ThrustParticle, velocity, sprite_width, position)

func _draw():
	if COMMON.black_and_white:
		color = Color(1, 1, 1)
	draw_and_add_collision()

func draw_and_add_collision():
	print("draw_and_add_collision not implemented")
	push_error("Not implemented")

func _on_area_entered(area):
	var free_from_queue = false
	if "Radar" in area.name:
		return
	elif "Player" in area.name:
		if !PLAYER.thrusting:
			area.die()
		if requires_multiple_hits:
			decrement_hits()
	elif requires_multiple_hits:
		decrement_hits()
		free_from_queue = true
	else: # only bullets
		get_parent().remove_child(area)
	
	die(area, free_from_queue)

func decrement_hits():
	extra_hits -= 1
	color.r += 0.1
	color.g += 0.1
	color.b += 0.1
	update()

func _On_Enemy_Area_Entered(area):
	print("On ENEMY AREA ENTERED?")
	push_error("I don't know if this is ever called")
	die(null)

func die(area, free_from_queue = true):
	var explosion = COMMON.generate_explosion(position)
	if free_from_queue and area != null:
		area.queue_free()
	if !requires_multiple_hits or extra_hits < 1:
		emit_signal("bullet_destroyed_enemy", self, area)
		remove_from_group("Enemy")
		death_point_display()
		self.queue_free()

func on_bomb_detonated():
	die(null)

func death_point_display():
	var fading_text = FADING_TEXT.instance()
	get_parent().add_child(fading_text)
	fading_text.setup(position, "+"+str(point_value * SCORE_MULTIPLIER.get_multiplier()))
	
