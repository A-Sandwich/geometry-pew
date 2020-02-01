extends "Enemy.gd"

func _ready():
	position.x = position.x + 100
	position.y = position.y + 100
	sprite_width = COMMON.get_screen_size(self).x / 100
	player_position = COMMON.get_screen_size(self) / 2
	color = Color(.15, .81, .25) #color is just random, need to figure out what I want
	print("Disk boi")

func process(delta):
	if !PLAYER.dead:
		move(delta)
	else:
		$ThrustParticle.emitting = false

func draw_and_add_collision():
	draw_circle(Vector2(0,0), sprite_width * 2, color)
	$CollisionShape2D.shape.radius = sprite_width * 2
