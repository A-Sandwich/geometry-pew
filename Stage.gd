extends Node2D

onready var COMMON = get_node("/root/Common")
var stage_size = Vector2(4000, 2200)

var color = Color(255, 255, 255)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.title = false
	var extent_vector = Vector2(-stage_size.x / 2, -stage_size.y / 2)
	var rect_size = Vector2(stage_size.x, stage_size.y)
	$BackgroundParticle.visibility_rect = Rect2( extent_vector, rect_size * 2)
	$PauseMenu.init(get_viewport_rect().size)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if COMMON.black_and_white:
		$BackgroundParticle.process_material.color = Color(0,0,0,1)
		$BackgroundParticle.process_material.hue_variation = 0
		$BackgroundParticle.process_material.hue_variation_random = 0
func get_rectangle_points(geometry_points):
	# draw operations are relative to the parent, so (0,0) is actually where the player is
	geometry_points.push_back(Vector2(-5, -5))
	geometry_points.push_back(Vector2(-5, stage_size.y+5))
	geometry_points.push_back(Vector2(stage_size.x+5, stage_size.y+5))
	geometry_points.push_back(Vector2(stage_size.x+5, -5))
	geometry_points.push_back(Vector2(-5, -5))
	return geometry_points

func _draw():
	var geometry_points = PoolVector2Array()
	
	geometry_points = get_rectangle_points(geometry_points)
	for index_point in range(geometry_points.size() - 1):
		draw_line(geometry_points[index_point], geometry_points[index_point + 1], color, 10)
