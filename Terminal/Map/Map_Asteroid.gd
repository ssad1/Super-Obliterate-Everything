extends Sprite2D

var radius = 10
var period = 0
var phase = 0
var phaseshift = 0
var astrophaseshift = 0
var ringcolor = 0
var center = Vector2(0,0)
var orbitr = 0
var bright = 0
var dir = 1

func _ready():
	pass

func _ignite():
	if(CALC._rand() > 0.25):
		radius = 16 * float(CALC._randint()%10+15) / 100
	else:
		radius = 16 * float(CALC._randint()%20+20) / 100
	set_scale(Vector2(radius / 16,radius / 16))
	bright = int(15 * radius)
	if(bright > 255):
		bright = 255
	modulate = Color8(bright,bright,bright,255)
	astrophaseshift = TAU * CALC._rand()
	#light_shadow.set_scale(Vector2(.6 * radius / 32,.6 * radius / 32))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var c
	phase = get_parent().phase
	c = int((bright + 50 * sin(phase / 50 + astrophaseshift)) * ringcolor)
	if(c > 255):
		c = 255
	if(c < 20):
		c = 20
	modulate = Color8(c,c,c,255)
	_do_orbit()

func _calculate_period(r,m):
	period = pow(pow(r,3) * 4 * pow(PI, 2) / (m),.5)
	phaseshift = CALC._rand() * period
	orbitr = r

func _do_orbit():
	set_position(Vector2(center[0] + orbitr * dir * sin(TAU * (phase + phaseshift)/period),center[1] + orbitr * cos(TAU * (phase + phaseshift)/period)))
