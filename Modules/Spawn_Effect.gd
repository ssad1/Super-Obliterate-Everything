extends Node

var up
@export var spawn_id:SPAWNER.spawn_objs = SPAWNER.spawn_objs.EFFECT_CLICK_BOOM
@export var scale_effect:bool = false
@export var scale_effect_size:float = 1
var is_type:String = "TRIGGER"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up = get_parent()
	up.modules.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _fire() -> void:
	var obj
	var sc := Vector2(1,1)
	var theta := randf() * 2 * PI
	obj = SPAWNER._spawn([spawn_id], null, up.pos, up.velocity, theta, 0, 0)
	if scale_effect:
		sc = up.up.scale
	sc = sc * scale_effect_size
	obj.set_scale(sc)
