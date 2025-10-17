extends Node2D

@export var build_sfx = 0
var clock = 0
var up
var is_type = "TRIGGER"

func _ready():
	up = get_parent()
	up.modules.append(self)

func _do_tick():
	if(clock == 1 && build_sfx != 0):
		if(up.player == SPAWNER.game.me):
			SFX._play_new([build_sfx])
	clock = clock + 1
