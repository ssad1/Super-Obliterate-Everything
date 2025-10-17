extends Light2D

var xx = 0
var yy = 0
var clock = 0

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clock = clock + delta
	xx = 650 * sin(clock * .3 + PI)
	yy = 200 * cos(clock * .3 + PI)
	set_position(Vector2(xx,yy))
