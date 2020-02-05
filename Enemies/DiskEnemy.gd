extends "Enemy.gd"

var dashing = false
var dashDirection: Vector2
var DASH_SPEED = 500

func _ready():
	color = Color(.15, .81, .25) #color is just random, need to figure out what I want
	print("Disk boi")
	$Radar.position = Vector2(0,0)

func process(delta):
	if !PLAYER.dead:
		move(delta)
	else:
		$ThrustParticle.emitting = false

func draw_and_add_collision():
	draw_circle(Vector2(0,0), sprite_width, color)
	$CollisionShape2D.shape.radius = sprite_width
	$Radar/RadarCollider.shape.radius = sprite_width * 6

func _on_Radar_area_entered(area):
	if $DashTimer.is_stopped() and "Bullet" in area.name:
		print("Starting dash timer")
		$DashTimer.start()
		dashing = true

func dash(direction):
	return direction.rotated(PI / 2)

func move(delta):
	var velocity = Vector2()  # The enemy's movement vector.
	var direction = (player_position - position).normalized()
	if dashing:
		direction = dash(direction)
		velocity = direction * DASH_SPEED
	else:
		velocity = direction * speed
	position += velocity * delta
	
	var stage_size = get_parent().stage_size
	if (position.x < -sprite_width or position.x > stage_size.x + sprite_width or
		position.y < -sprite_width or position.y > stage_size.y + sprite_width):
		visible = false
	else:
		visible = true
	COMMON.thrust($ThrustParticle, velocity, sprite_width, position)


func _on_DashTimer_timeout():
	print("dahs timer timeout!")
	dashing = false
	$DashTimer.stop()
