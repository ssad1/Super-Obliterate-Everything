extends Sprite2D

# Declare member variables here. Examples:
var clock = 0
var phaseshift = 0
var starred = 255
var stargreen = 255
var starblue = 255
var starscale = 1
var d = .5 * randf() + .5
var fade = 1
var smode = 1 #0: hyperspace, 1:background
var start_position = Vector2(0,0)
var parallax = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("starmode", Callable(self,"_starmode"))
	_ignite()

func _ignite():
	var colorshift = CALC._randint() % 5
	if CALC._randint() % 3 > 0:
		colorshift = 4
	phaseshift = CALC._rand() * TAU
	starscale = pow(CALC._rand() * .6 + .3,3) + .1
	parallax = .75 * starscale + CALC._rand() * .25
	set_position(Vector2(int(CALC._rand() * GLOBAL.resx),int(CALC._rand() * GLOBAL.resy)))
	start_position = position
	set_scale(Vector2(starscale,starscale))
	match colorshift:
		0:
			starred = 255
			stargreen = 238
			starblue = 192
		1:
			starred = 255
			stargreen = 191
			starblue = 153
		2:
			starred = 255
			stargreen = 158
			starblue = 150
		3:
			starred = 171
			stargreen = 167
			starblue = 190
		4:
			starred = 255
			stargreen = 255
			starblue = 255
		5:
			starred = 253
			stargreen = 84
			starblue = 65
		6:
			starred = 103
			stargreen = 8
			starblue = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos:Vector2
	var center = Vector2(.5 * GLOBAL.resx, .5 * GLOBAL.resy)
	clock = clock + delta
	if(fade < 1):
		fade = fade + .1 * delta
		if(fade > 1):
			fade = 1
	if(smode == 0):
		pos = position
		pos = pos - center
		pos = pos * (1 + .05 * delta * d)
		pos = pos + center
		set_position(pos)
		if(pos.x < -10 || pos.x > GLOBAL.resx + 10 || pos.y < -10 || pos.y > GLOBAL.resy):
			var t = randf()
			var r = 50 + 300 * randf()
			pos = Vector2(r * cos(TAU * t),r * sin(TAU * t))
			set_position(pos + center)
			fade = 0
	if(smode == 1 && SPAWNER.game != null):
		set_position(start_position + 0.0175 * pow(parallax, 3) * SPAWNER.game.position)
		#set_position(start_position + SPAWNER.game.position)
		pos = position
		if(pos.x + 24 < 0):
			pos.x = pos.x + GLOBAL.resx + 48
			set_position(pos)
		if(pos.y + 24 < 0):
			pos.y = pos.y + GLOBAL.resy + 48
			set_position(pos)
		if(pos.x - 24 > GLOBAL.resx):
			pos.x = pos.x - GLOBAL.resx - 48
			set_position(pos)
		if(pos.y - 24 > GLOBAL.resy):
			pos.y = pos.y - GLOBAL.resy - 48
			set_position(pos)
	modulate = Color8(starred,stargreen,starblue,int(fade * 255 * (.6 + .4 * sin(clock + phaseshift))))

func _starmode(mode):
	smode = mode
	_ignite()
