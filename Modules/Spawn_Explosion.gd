extends Node

var up
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
	if(get_child_count() > 0):
		obj = SPAWNER._spawn_dupe(get_child(0), null, up.pos, up.velocity, theta, 0, 0)
		if(scale_effect == true):
			sc = up.up.scale
		sc = sc * scale_effect_size
		obj.set_scale(sc)
		if("boom_scale" in obj):
			obj.boom_scale = obj.boom_scale * sc.x
		if("flash_scale" in obj):
			obj.flash_scale = obj.flash_scale * sc.x
		if("smoke_scale" in obj):
			obj.smoke_scale = obj.smoke_scale * sc.x
		if("spark_scale" in obj):
			obj.spark_scale = obj.spark_scale * sc.x
