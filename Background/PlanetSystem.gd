extends Node2D

@onready var Planet = preload("res://Background/Planet.tscn")
@onready var Planet_Rocky_1 = preload("res://Background/Planets/Planet_Rocky_1.tscn")
@onready var Planet_Rocky_2 = preload("res://Background/Planets/Planet_Rocky_2.tscn")
@onready var Planet_Rocky_3 = preload("res://Background/Planets/Planet_Rocky_3.tscn")
@onready var Planet_Rocky_4 = preload("res://Background/Planets/Planet_Rocky_4.tscn")
@onready var Planet_Rocky_5 = preload("res://Background/Planets/Planet_Rocky_5.tscn")
@onready var Planet_Rocky_6 = preload("res://Background/Planets/Planet_Rocky_6.tscn")
@onready var Planet_Rocky_7 = preload("res://Background/Planets/Planet_Rocky_7.tscn")
@onready var Planet_Rocky_8 = preload("res://Background/Planets/Planet_Rocky_8.tscn")
@onready var Planet_Lava_1 = preload("res://Background/Planets/Planet_Lava_1.tscn")
@onready var Planet_Lava_2 = preload("res://Background/Planets/Planet_Lava_2.tscn")
@onready var Planet_Lava_3 = preload("res://Background/Planets/Planet_Lava_3.tscn")
@onready var Planet_Lava_4 = preload("res://Background/Planets/Planet_Lava_4.tscn")
@onready var Planet_Lava_5 = preload("res://Background/Planets/Planet_Lava_5.tscn")
@onready var Planet_Lava_6 = preload("res://Background/Planets/Planet_Lava_6.tscn")
@onready var Planet_Lava_7 = preload("res://Background/Planets/Planet_Lava_7.tscn")
@onready var Planet_Lava_8 = preload("res://Background/Planets/Planet_Lava_8.tscn")
@onready var Planet_Ice_1 = preload("res://Background/Planets/Planet_Ice_1.tscn")
@onready var Planet_Ice_2 = preload("res://Background/Planets/Planet_Ice_2.tscn")
@onready var Planet_Ice_3 = preload("res://Background/Planets/Planet_Ice_3.tscn")
@onready var Planet_Ice_4 = preload("res://Background/Planets/Planet_Ice_4.tscn")
@onready var Planet_Ice_5 = preload("res://Background/Planets/Planet_Ice_5.tscn")
@onready var Planet_Ice_6 = preload("res://Background/Planets/Planet_Ice_6.tscn")
@onready var Planet_Ice_7 = preload("res://Background/Planets/Planet_Ice_7.tscn")
@onready var Planet_Ice_8 = preload("res://Background/Planets/Planet_Ice_8.tscn")
@onready var Planet_Mars_1 = preload("res://Background/Planets/Planet_Mars_1.tscn")
@onready var Planet_Mars_2 = preload("res://Background/Planets/Planet_Mars_2.tscn")
@onready var Planet_Mars_3 = preload("res://Background/Planets/Planet_Mars_3.tscn")
@onready var Planet_Mars_4 = preload("res://Background/Planets/Planet_Mars_4.tscn")
@onready var Planet_Mars_5 = preload("res://Background/Planets/Planet_Mars_5.tscn")
@onready var Planet_Mars_6 = preload("res://Background/Planets/Planet_Mars_6.tscn")
@onready var Planet_Mars_7 = preload("res://Background/Planets/Planet_Mars_7.tscn")
@onready var Planet_Mars_8 = preload("res://Background/Planets/Planet_Mars_8.tscn")
@onready var Planet_Water_1 = preload("res://Background/Planets/Planet_Water_1.tscn")
@onready var Planet_Water_2 = preload("res://Background/Planets/Planet_Water_2.tscn")
@onready var Planet_Water_3 = preload("res://Background/Planets/Planet_Water_3.tscn")
@onready var Planet_Water_4 = preload("res://Background/Planets/Planet_Water_4.tscn")
@onready var Planet_Titan_1 = preload("res://Background/Planets/Planet_Titan_1.tscn")
@onready var Planet_Titan_2 = preload("res://Background/Planets/Planet_Titan_2.tscn")
@onready var Planet_Titan_3 = preload("res://Background/Planets/Planet_Titan_3.tscn")
@onready var Planet_Titan_4 = preload("res://Background/Planets/Planet_Titan_4.tscn")

var planets = []
var fade = 255
var fadeset = 255

func _ready():
	var s
	EVENTS.connect("flipload", Callable(self,"_flipload"))
	EVENTS.connect("fadeset", Callable(self,"_fadeset"))
	set_position(Vector2(.5 * GLOBAL.resx,.5 * GLOBAL.resy))
	#_gen_planets()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(fade < fadeset):
		fade = fade + 200 * delta
	if(fade > fadeset):
		fade = fade - 200 * delta
	if(fade + 3 > fadeset && fade - 3 < fadeset):
		fade = fadeset
	if(fade > 255):
		fade = 255
	if(fade < 0):
		fade = 0
	#modulate = Color8(fade,fade,fade,255)

func _flipload():
	if(GLOBAL.nextscreen == 0):
		_clear_planets()
		#_gen_planets()
	if(GLOBAL.nextscreen == 1):
		_clear_planets()
		#_gen_planets()
	if(GLOBAL.nextscreen == 2):
		_clear_planets()

func _clear_planets():
	var i
	i = planets.size() - 1
	while i > -1:
		planets[i].queue_free()
		planets.remove_at(i)
		i = i - 1

func _gen_planets():
	for i in range(1):
		var p
		print("Planet: " + str(LEVELS.level_planet))
		p = _select_planet(LEVELS.level_planet)
		if(i == 0):
			p._ignite(0)
		if(i > 0):
			p._ignite(1)
		planets.append(p)
		add_child(p)

func _select_planet(s):
	var i
	var sb = 0
	var p
	var rocky = [1,2,3,4,5,6,7,8]
	var lava = [10,11,12,13,14,15,16,17]
	var ice = [20,21,22,23,24,25,26,27]
	var mars = [28,29,30,31,32,33,34,35]
	var water = [36,37,38,39]
	var titan = [40,41,42,43]
	match s:
		"ROCKY":
			sb = rocky[CALC._randint() % rocky.size()]
		"LAVA":
			sb = lava[CALC._randint() % lava.size()]
		"ICY":
			sb = ice[CALC._randint() % ice.size()]
		"MARS":
			sb = mars[CALC._randint() % mars.size()]
		"WATER":
			sb = water[CALC._randint() % water.size()]
		"TITAN":
			sb = titan[CALC._randint() % titan.size()]
	match sb:
		1:
			p = Planet_Rocky_1.instantiate()
		2:
			p = Planet_Rocky_2.instantiate()
		3:
			p = Planet_Rocky_3.instantiate()
		4:
			p = Planet_Rocky_4.instantiate()
		5:
			p = Planet_Rocky_5.instantiate()
		6:
			p = Planet_Rocky_6.instantiate()
		7:
			p = Planet_Rocky_7.instantiate()
		8:
			p = Planet_Rocky_8.instantiate()
		10:
			p = Planet_Lava_1.instantiate()
		11:
			p = Planet_Lava_2.instantiate()
		12:
			p = Planet_Lava_3.instantiate()
		13:
			p = Planet_Lava_4.instantiate()
		14:
			p = Planet_Lava_5.instantiate()
		15:
			p = Planet_Lava_6.instantiate()
		16:
			p = Planet_Lava_7.instantiate()
		17:
			p = Planet_Lava_8.instantiate()
		20:
			p = Planet_Ice_1.instantiate()
		21:
			p = Planet_Ice_2.instantiate()
		22:
			p = Planet_Ice_3.instantiate()
		23:
			p = Planet_Ice_4.instantiate()
		24:
			p = Planet_Ice_5.instantiate()
		25:
			p = Planet_Ice_6.instantiate()
		26:
			p = Planet_Ice_7.instantiate()
		27:
			p = Planet_Ice_8.instantiate()
		28:
			p = Planet_Mars_1.instantiate()
		29:
			p = Planet_Mars_2.instantiate()
		30:
			p = Planet_Mars_3.instantiate()
		31:
			p = Planet_Mars_4.instantiate()
		32:
			p = Planet_Mars_5.instantiate()
		33:
			p = Planet_Mars_6.instantiate()
		34:
			p = Planet_Mars_7.instantiate()
		35:
			p = Planet_Mars_8.instantiate()
		36:
			p = Planet_Water_1.instantiate()
		37:
			p = Planet_Water_2.instantiate()
		38:
			p = Planet_Water_3.instantiate()
		39:
			p = Planet_Water_4.instantiate()
		40:
			p = Planet_Titan_1.instantiate()
		41:
			p = Planet_Titan_2.instantiate()
		42:
			p = Planet_Titan_3.instantiate()
		43:
			p = Planet_Titan_4.instantiate()
	return p

func _fadeset(dim):
	fadeset = dim
