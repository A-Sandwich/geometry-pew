extends "Enemy.gd"

var dashing = false
var dashDirection: Vector2
var DASH_SPEED = 500

func _ready():
	ready()

func ready():
	color = Color(1, .08, .58)
	$Radar.position = Vector2(0,0)
	point_value = 200

func process(delta):
	if !PLAYER.dead:
		move(delta)
	else:
		$ThrustParticle.emitting = false

func draw_and_add_collision():
	draw_circle(Vector2(0,0), sprite_width, color)
	$CollisionShape2D.shape.radius = sprite_width
	$Radar/RadarCollider.shape.radius = sprite_width * 6

func dash(direction):
	return direction.rotated(PI / 2)

# Todo: Break this out into multiple methods, too long
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

func _on_Radar_area_entered(area):
	if $DashTimer.is_stopped() and "Bullet" in area.name:
		$DashTimer.start()
		dashing = true
