extends Node2D

var radius = 10
var period = 0
var phase = 0
var phaseshift = 0
var center = Vector2(0,0)
var orbitr = 0
var dir = 1
var scale_factor = 1
var selected = false
var true_scale = 1
var hover_alpha = 0
var temp = "TEMPERATE"
var asteroids = ""
var planet_type = ""
var star_heat = 0

func _ready():
	pass

func _ignite():
	if(CALC._rand() > 0.25):
		radius = 32 * float(CALC._randint()%10+10) / 100
	else:
		radius = 32 * float(CALC._randint()%50+10) / 100
	scale_factor = radius / 32
	$Sprite_Planet.set_scale(Vector2(scale_factor,scale_factor))
	$BallGlow.set_scale(Vector2(1.1 * scale_factor,1.1 * scale_factor))
	$Sprite_Planet.modulate = Color(1,1,1)
	if(1.2 * scale_factor < .5):
		$MissionHover.set_scale(Vector2(.5, .5))
	else:
		$MissionHover.set_scale(Vector2(1.2 * scale_factor, 1.2 * scale_factor))
	#light_shadow.set_scale(Vector2(.6 * radius / 32,.6 * radius / 32))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	phase = get_parent().phase
	_do_orbit()
	if(selected == true):
		if(true_scale < 1.5):
			true_scale = true_scale + delta * 10
		if(true_scale > 1.5):
			true_scale = 1.5
		if(hover_alpha < 1):
			hover_alpha = hover_alpha + delta * 6
		if(hover_alpha > 1):
			hover_alpha = 1
	if(selected == false):
		if(true_scale > 1):
			true_scale = true_scale - delta * 10
		if(true_scale < 1):
			true_scale = 1
		if(hover_alpha > 0):
			hover_alpha = hover_alpha - delta * 2
		if(hover_alpha < 0):
			hover_alpha = 0
		hover_alpha = 0
	self.set_scale(Vector2(true_scale, true_scale))
	$MissionHover.modulate = Color(1,1,1,hover_alpha)

func _calculate_period(r,m):
	period = pow(pow(r,3) * 4 * pow(PI, 2) / (m),.5)
	phaseshift = CALC._rand() * period
	orbitr = r

func _calculate_temp():
	var t
	temp = "TEMPERATE"
	t = round(100 - 100 * orbitr / 500 + star_heat)
	if(t < 105):
		temp = "COLD"
	if(t < 85):
		temp = "VERY COLD"
	if(t > 125):
		temp = "HOT"
	if(t > 145):
		temp = "VERY HOT"
	if(t > 165):
		temp = "INFERNO"

func _do_orbit():
	set_position(Vector2(center[0] + orbitr * dir * sin(TAU * (phase + phaseshift)/period),center[1] + orbitr * cos(TAU * (phase + phaseshift)/period)))
	_calculate_temp()
	if(planet_type == ""):
		planet_type = _select_planet_type()
	if(asteroids == ""):
		asteroids = _select_asteroids(temp)
	_temp_color()
	if(dir > 0):
		$BallGlow.set_position(Vector2((3 * (radius / 32) + 1) * dir * sin(TAU * (phase + phaseshift)/period + PI),(3 * (radius / 32) + 1) * dir * cos(TAU * (phase + phaseshift)/period + PI)))
	else:
		$BallGlow.set_position(Vector2((3 * (radius / 32) + 1) * dir * sin(TAU * (phase + phaseshift)/period + PI),-(3 * (radius / 32) + 1) * dir * cos(TAU * (phase + phaseshift)/period + PI)))

func _select_asteroids(s):
	var basic_set = ["ROCKY","STONY","METALLIC","CHONDRITE"]
	var final_set = []
	var selected = "METALLIC"
	match s:
		"INFERNO":
			final_set = ["LAVA"]
		"VERY HOT":
			final_set = ["LAVA"]
		"HOT":
			final_set = basic_set + ["LAVA"] + ["LAVA"] + ["LAVA"] + ["LAVA"]
		"TEMPERATE":
			final_set = basic_set
		"COLD":
			final_set = basic_set + ["ICY"] + ["ICY"] + ["ICY"] + ["ICY"]
		"VERY COLD":
			final_set = ["ICY"]
	if(final_set.size() > 0):
		selected = final_set[CALC._randint() % final_set.size()]
	return selected

func _select_planet_type():
	var basic_set = ["ROCKY","TITAN", "MARS"]
	var final_set = []
	var selected = "ROCKY"
	match temp:
		"INFERNO":
			final_set = ["LAVA"]
		"VERY HOT":
			final_set = ["LAVA"]
		"HOT":
			final_set = basic_set + ["LAVA"]
		"TEMPERATE":
			final_set = basic_set + ["WATER"]
		"COLD":
			final_set = basic_set + ["ICY"]
		"VERY COLD":
			final_set = ["ICY"]
	if(final_set.size() > 0):
		selected = final_set[CALC._randint() % final_set.size()]
	if(radius > 32):
		selected = "GAS GIANT"
	return selected

func _temp_color():
	match temp:
		"VERY COLD":
			$Sprite_Planet.modulate = Color(.5,.5,1)
			$BallGlow.modulate = Color(.5,.5,1)
		"COLD":
			$Sprite_Planet.modulate = Color(.7,.7,1)
			$BallGlow.modulate = Color(.7,.7,1)
		"TEMPERATE":
			$Sprite_Planet.modulate = Color(1,1,1)
			$BallGlow.modulate = Color(1,1,1)
		"HOT":
			$Sprite_Planet.modulate = Color(1,.7,.7)
			$BallGlow.modulate = Color(1,.7,.7)
		"VERY HOT":
			$Sprite_Planet.modulate = Color(1,.5,.5)
			$BallGlow.modulate = Color(1,.5,.5)
		"INFERNO":
			$Sprite_Planet.modulate = Color(2,.5,.5)
			$BallGlow.modulate = Color(2,.5,.5)
