extends Node2D

var is_type = "STATS"
@onready var range_line = $Range_Line
@onready var shield_line = $Shield_Line
@onready var armor = $Armor
@onready var armorback = $ArmorBack
@onready var shield = $Shield
@onready var shieldback = $ShieldBack
@onready var areashield = $AreaShield
var fade_in = true
var fade_alpha = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(1,1,1,fade_alpha)
	range_line.scale = Vector2(.5,.5)
	shield_line.scale = Vector2(1.2,1.2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(fade_in == true):
		fade_alpha = fade_alpha + 5 * delta
		if(fade_alpha >= 1):
			fade_alpha = 1
			fade_in = false
	modulate = Color(1,1,1,fade_alpha)
	range_line.scale = Vector2(.5 + .5 * fade_alpha,.5 + .5 * fade_alpha)
	shield_line.scale = Vector2(1.2 - .2 * fade_alpha,1.2 - .2 * fade_alpha)

func _do_tick():
	pass

func _gen_circle(l,r):
	var theta = 0.0
	var samples = 0
	var p
	l.clear_points()
	samples = round(2 * PI * r / 10)
	theta = 0
	for i in range(samples + 1):
		p = Vector2(r * sin(theta),r * cos(theta))
		l.add_point(p)
		theta = theta + 2 * PI / samples

func _set_stats(a,s,sb,r,sr):
	if(r > 0):
		_gen_circle(range_line,r)
	else:
		range_line.clear_points()
	if(sr > 0):
		_gen_circle(shield_line,sr)
	else:
		shield_line.clear_points()
	armor.scale = Vector2(a,1)
	shield.scale = Vector2(s,1)
	areashield.scale = Vector2(sb,1)
	armor.modulate = Color(1,0,0,1)
	if(a >= 0.33):
		armor.modulate = Color(1,.8,.4,1)
	if(a >= 0.66):
		armor.modulate = Color(1,1,1,1)
	if(s == 0):
		shield.hide()
	else:
		shield.show()
	if(sb == 0):
		areashield.hide()
	else:
		areashield.show()
	if(s == 0 && sb == 0):
		shieldback.hide()
	else:
		shieldback.show()
	if(a == 0):
		armor.hide()
		armorback.hide()
	else:
		armor.show()
		armorback.show()
