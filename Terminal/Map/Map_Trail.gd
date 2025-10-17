extends Line2D

var orbitr = 0
var phase = 0
var phaseshift = 0
var period = 0
var dir = 1

func _ready():
	pass # Replace with function body.

func _process(delta):
	phase = get_parent().phase
	_do_orbit()

func _draw_line(r,p):
	var point
	orbitr = r
	period = p
	for theta in range(60000/p):
		point = Vector2(r * dir * sin(float(-1 * theta)/20),r * cos(float(-1 * theta)/20))
		add_point(point)

func _do_orbit():
	var point = Vector2(orbitr * dir * sin(TAU * (phase + phaseshift)/period),orbitr * cos(TAU * (phase + phaseshift)/period))
	rotation = -1 * atan2(point.x,point.y)
