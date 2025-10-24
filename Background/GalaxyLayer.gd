extends Node2D

@onready var Galaxy = preload("res://Background/Galaxy.tscn")
@onready var Elliptical = preload("res://Background/Elliptical.tscn")
@onready var Irregular = preload("res://Background/Irregular.tscn")

var galaxies = []
var fade = 255
var fadeset = 255

func _ready():
	var s
	EVENTS.connect("flipload", Callable(self, "_flipload"))
	EVENTS.connect("fadeset", Callable(self, "_fadeset"))
	set_position(Vector2(0,0))
	_gen_galaxies()

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
	modulate = Color8(255,255,255,int(fade))
	pass

func _gen_galaxies():
	var total = CALC._randint() % 35 + 15
	var g
	CALC.rseed = LEVELS.level_seed
	for i in total:
		g = Galaxy.instantiate()
		galaxies.append(g)
		add_child(g)
	total = CALC._randint() % 35 + 15
	for i in total:
		g = Elliptical.instantiate()
		galaxies.append(g)
		add_child(g)
	total = CALC._randint() % 35 + 15
	for i in total:
		g = Irregular.instantiate()
		galaxies.append(g)
		add_child(g)

func _clear_galaxies():
	var i
	i = galaxies.size() - 1
	while i > -1:
		galaxies[i].queue_free()
		galaxies.remove_at(i)
		i = i - 1

func _flipload():
	if(GLOBAL.nextscreen == 0):
		_clear_galaxies()
		_gen_galaxies()
	if(GLOBAL.nextscreen == 1):
		_clear_galaxies()
		#_gen_galaxies()
	if(GLOBAL.nextscreen == 2):
		_clear_galaxies()
		_gen_galaxies()

func _fadeset(dim):
	fadeset = dim