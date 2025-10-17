extends Sprite2D

# Declare member variables here. Examples:
var clock = 0
var phaseshift = 0
var starscale = 1
var d = .5 * randf() + .5
var fade = 1
var dmode = 0 #0: snow
var start_position := Vector2(0,0)
var parallax = 1
var velocity := Vector2(0,0)
var oldgame := Vector2(0,0)
var drift_t = 0
var rv = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("starmode", Callable(self,"_starmode"))
	_ignite()

func _ignite():
	randomize()
	phaseshift = randf() * TAU
	starscale = pow(randf() * .6 + .3,3) + .1
	parallax = .8 * starscale + randf() * .2 + 1
	set_position(Vector2(int(randf() * GLOBAL.resx),int(randf() * GLOBAL.resy)))
	start_position = position
	set_scale(1 * Vector2(starscale,starscale))
	velocity = Vector2(8 * (randf() - .5), 8 * (randf() - .5))
	rv = 1 * (randf() - .5)
	set_frame(randi() % 4)
	set_rotation(randf() * 2 * PI)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos:Vector2
	var center = Vector2(.5 * GLOBAL.resx, .5 * GLOBAL.resy)
	clock = clock + delta
	if(fade < 1):
		fade = fade + .1 * delta
		if(fade > 1):
			fade = 1
	if(dmode == 0 && SPAWNER.game != null):
		#set_position(start_position + pow(parallax, 2) * SPAWNER.game.position)
		#set_position(start_position + SPAWNER.game.position)
		pos = position
		pos = pos + pow(parallax, 2) * (-1 * oldgame + SPAWNER.game.position)
		oldgame = SPAWNER.game.position
		drift_t = drift_t + delta
		if(drift_t > .2):
			velocity = velocity + 6 * Vector2(randf() - .5,randf() - .5)
			drift_t = drift_t - .2
			if(velocity.length() > 16):
				velocity = velocity * .9
		pos = pos + velocity * delta * pow(parallax, 2)
		set_rotation(get_rotation() + rv * delta)
		set_position(pos)
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
	modulate = Color8(230,240,255,int(fade * 15 * (.6 + .4 * sin(1.5 * clock + phaseshift))))

func _dustmode(mode):
	dmode = mode
	_ignite()
