extends Area2D

onready var COMMON = get_node("/root/Common")
onready var HUD = get_parent().get_node("HUD")
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
var speed_range = Vector2(100, 550)
var sprite_width

# Called when the node enters the scene tree for the first time.
func _ready():
	if PLAYER != null:
		PLAYER.connect("bomb_detonated", self, "on_bomb_detonated")
	add_to_group("Enemy")
	self.connect("bullet_destroyed_enemy", HUD, "on_enemy_destroyed")
	self.connect("area_entered", self, "_on_area_entered")
	sprite_width = COMMON.get_screen_size(self).x / 100
	player_position = COMMON.get_screen_size(self) / 2
	stage_size = STAGE.stage_size
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

func move(delta):
	var velocity = Vector2()  # The enemy's movement vector.
	var direction = (player_position - position).normalized()

	velocity = direction * speed
	position += velocity * delta
	
	var stage_size = get_parent().stage_size
	if (position.x < -sprite_width or position.x > stage_size.x + sprite_width or
		position.y < -sprite_width or position.y > stage_size.y + sprite_width):
		visible = false
	else:
		visible = true
	COMMON.thrust($ThrustParticle, velocity, sprite_width, position)

func _draw():
	draw_and_add_collision()

func draw_and_add_collision():
	print("draw_and_add_collision not implemented")
	push_error("Not implemented")

func _on_area_entered(area):
	speed = 0
	print("Enemy Entered "+str(area.name))
	if "Radar" in area.name:
		return
	elif "Player" in area.name:
		print("Player is thrusting: "+str(PLAYER.thrusting))
		if !PLAYER.thrusting:
			area.dead = true
			return
	die(area)

func die(area):
	print("Enemy Dying " + area.name)
	emit_signal("bullet_destroyed_enemy", self, area)
	remove_from_group("Enemy")
	death_point_display()
	self.queue_free()

func on_bomb_detonated():
	die(null)

func death_point_display():
	#create label
	var fading_text = FADING_TEXT.instance()
	get_parent().add_child(fading_text)
	fading_text.setup(position, "+"+str(point_value))
	
