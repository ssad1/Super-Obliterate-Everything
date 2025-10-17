extends Line2D

var builder
var build_spot = Vector2(0,0)

func _ready():
	pass # Replace with function body.

func _process(delta):
	var destroy = false
	clear_points()
	if(weakref(builder).get_ref() != null):
		if("is_type" in builder):
			if(builder.is_type != "SHIP"):
				destroy = true
			else:
				if(builder.build_mission != null):
					add_point(build_spot)
					add_point(builder.position)
				else:
					destroy = true
		else:
			destroy = true
	else:
		destroy = true
	if(destroy == true):
		builder = null
		queue_free()
		
func _ignite(b,bs):
	builder = b
	build_spot = bs
