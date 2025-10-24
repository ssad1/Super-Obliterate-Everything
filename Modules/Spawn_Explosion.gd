extends Node

var up
@export var scale_effect:bool = false
@export var scale_effect_size:float = 1
var is_type:String = "TRIGGER"

func _ready() -> void:
	up = get_parent()
	up.modules.append(self)

func _fire() -> void:
	var obj
	var sc := Vector2(1,1)
	var theta := randf() * 2 * PI
	
	if get_child_count() == 0: return

	obj = SPAWNER._spawn_dupe(get_child(0), null, up.pos, up.velocity, theta, 0, 0)
	if scale_effect:
		sc = up.up.scale
	sc = sc * scale_effect_size
	obj.set_scale(sc)
	if "boom_scale" in obj:
		obj.boom_scale = obj.boom_scale * sc.x
	if "flash_scale" in obj:
		obj.flash_scale = obj.flash_scale * sc.x
	if "smoke_scale" in obj:
		obj.smoke_scale = obj.smoke_scale * sc.x
	if "spark_scale" in obj:
		obj.spark_scale = obj.spark_scale * sc.x
