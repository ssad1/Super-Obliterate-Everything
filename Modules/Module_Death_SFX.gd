extends Node

var up
@export var fire_sound:SFX.sound = 0
var is_type = "TRIGGER"

# Called when the node enters the scene tree for the first time.
func _ready():
	up = get_parent()
	up.modules.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _fire():
	if(fire_sound != 0):
		SFX._play_new([fire_sound])
