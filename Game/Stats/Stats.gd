class_name Stats
extends Node2D

var is_type:UNIT_STATE.type = UNIT_STATE.type.STATS
@onready var range_line:Line2D = $Range_Line
@onready var shield_line:Line2D = $Shield_Line
@onready var armor:Sprite2D = $Armor
@onready var armorback:Sprite2D = $ArmorBack
@onready var shield:Sprite2D = $Shield
@onready var shieldback:Sprite2D = $ShieldBack
@onready var areashield:Sprite2D = $AreaShield

var _faded:bool = true
var fade_in:bool = _faded
''':
	get:
		return _faded
	set(value):
		if value:
			UNIT_STATE.fade_stats(self, 0, 1)
		else:
			UNIT_STATE.fade_stats(self, 1, 0)
		
		_faded = value'''

var fade_alpha:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(1,1,1,0)
	range_line.scale = Vector2(.5,.5)
	shield_line.scale = Vector2(1.2,1.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:

	if fade_in:
		fade_alpha = fade_alpha + 5 * delta
		if fade_alpha >= 1:
			fade_alpha = 1
			fade_in = false

	modulate = Color(1,1,1,fade_alpha)
	range_line.scale = Vector2(.5 + .5 * fade_alpha,.5 + .5 * fade_alpha)
	shield_line.scale = Vector2(1.2 - .2 * fade_alpha,1.2 - .2 * fade_alpha)

func _do_tick() -> void:
	pass

func _gen_circle(l:Line2D, r:float) -> void:
	var theta := 0.0
	var samples := 0
	var p:Vector2
	l.clear_points()
	samples = round(TAU * r / 10)
	theta = 0
	for i in samples + 1:
		p = Vector2(r * sin(theta),r * cos(theta))
		l.add_point(p)
		theta = theta + TAU / samples

func _set_stats(a:float, s:float, sb:float, r:float, sr:float) -> void:

	if r > 0:
		_gen_circle(range_line,r)
	else:
		range_line.clear_points()

	if sr > 0:
		_gen_circle(shield_line,sr)
	else:
		shield_line.clear_points()

	armor.scale = Vector2(a,1)
	shield.scale = Vector2(s,1)
	areashield.scale = Vector2(sb,1)
	armor.modulate = Color(1,0,0,1)

	if a >= 0.33:
		armor.modulate = Color(1,.8,.4,1)

	if a >= 0.66:
		armor.modulate = Color(1,1,1,1)

	if s == 0:
		shield.hide()
	else:
		shield.show()

	if sb == 0:
		areashield.hide()
	else:
		areashield.show()

	if s == 0 && sb == 0:
		shieldback.hide()
	else:
		shieldback.show()

	if a == 0:
		armor.hide()
		armorback.hide()
	else:
		armor.show()
		armorback.show()
