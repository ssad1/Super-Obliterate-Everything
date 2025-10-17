extends Light2D

# Declare member variables here. Examples:
var theta
var anim_mode = 0
var anim_clock = 0

# Called when the node enters the scene tree for the first time.

func _ready():
	_set_lights()
	EVENTS.connect("lightset", Callable(self,"_lightset"))
	EVENTS.connect("envset", Callable(self,"_envset"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos := Vector2(0,0)
	var adjust := Vector2(0,0)
	var anim := Vector2(0,0)
	var g = get_parent()
	adjust.x = -1 * g.position.x + .5 * GLOBAL.resx
	adjust.y = -1 * g.position.y + .5 * GLOBAL.resy
	if(anim_mode != 0):
		anim = _anim_coords(delta)
	pos.x = 6000 * cos(theta) + adjust.x + anim.x
	pos.y = -6000 * sin(theta) + adjust.y + anim.y
	set_position(pos)

func _lightset(light, bright):
	color = light
	energy = 20 * bright

func _set_lights():
	var style
	CALC.rseed = LEVELS.level_seed
	style = CALC._rand() * 2
	if(style < 1):
		theta = CALC._rand() * PI + PI
		set_height(-300 - CALC._randint() % 1000)
	if(style >= 1):
		theta = CALC._rand() * PI / 2 - PI / 4
		if(CALC._rand() > 0.5):
			theta = theta + PI
		set_height(CALC._randint() % 1500)

func _envset(s,a,d):
	match s:
		2:
			match d:
				0:
					theta = 0
				1:
					theta = PI
				2:
					theta = PI / 2
				3:
					theta = 3 * PI / 2
		3:
			match d:
				0:
					theta = 0
					anim_mode = 1
				1:
					theta = PI
					anim_mode = 1
				2:
					theta = PI / 2
					anim_mode = 2
				3:
					theta = 3 * PI / 2
					anim_mode = 2

func _anim_coords(delta):
	var anim = Vector2(0,0)
	anim_clock = anim_clock + delta
	match anim_mode:
		1: #Up Down
			energy = 20 + 20 * sin(2.6 * anim_clock)
			anim.y = 6000 * sin(anim_clock)
		2: #Left Right
			energy = 20 + 20 * sin(2.6 * anim_clock)
			anim.x = 6000 * sin(anim_clock)
	return anim
