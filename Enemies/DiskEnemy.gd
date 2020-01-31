extends "Enemy.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = position.x + 100
	position.y = position.y + 100
	sprite_width = COMMON.get_screen_size(self).x / 100
	player_position = COMMON.get_screen_size(self) / 2
	add_to_group("Enemy")
	self.connect("bullet_destroyed_enemy", HUD, "on_enemy_destroyed")
	if PLAYER != null:
		PLAYER.connect("location_change", self, "on_location_change")
		PLAYER.connect("bomb_detonated", self, "on_bomb_detonated")
	print("Disk boi")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
