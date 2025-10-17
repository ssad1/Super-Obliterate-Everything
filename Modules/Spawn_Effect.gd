extends Node

var up
@export var spawn_id = 10000
@export var scale_effect = false
@export var scale_effect_size = 1.0
var is_type = "TRIGGER"

# Called when the node enters the scene tree for the first time.
func _ready():
	up = get_parent()
	up.modules.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _fire():
	var obj
	var sc = Vector2(1,1)
	var theta = randf() * 2 * PI
	obj = SPAWNER._spawn([spawn_id], null, up.pos, up.velocity, theta, 0, 0)
	if(scale_effect == true):
		sc = up.up.scale
	sc = sc * scale_effect_size
	obj.set_scale(sc)
