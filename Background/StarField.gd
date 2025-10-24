extends Node2D

@onready var StarA = preload("res://Background/StarA.tscn")
@onready var StarB = preload("res://Background/StarB.tscn")

var stars = []
var fade = 255
var fadeset = 255

func _ready():
	var s
	EVENTS.connect("flipload", Callable(self,"_flipload"))
	EVENTS.connect("fadeset", Callable(self,"_fadeset"))
	set_position(Vector2(0,0))
	_gen_stars()
	

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
	modulate = Color8(255,255,255,int(fade))

func _flipload():
	if(GLOBAL.nextscreen == 0):
		_clear_stars()
		_gen_stars()
	if(GLOBAL.nextscreen == 1):
		_clear_stars()
		#_gen_stars()
	if(GLOBAL.nextscreen == 2):
		_clear_stars()
		_gen_stars()

func _clear_stars():
	var i
	i = stars.size() - 1
	while i > -1:
		stars[i].queue_free()
		stars.remove_at(i)
		i = i - 1

func _gen_stars():
	#$DeepStars._gen_stars()
	var s
	CALC.rseed = LEVELS.level_seed
	for i in 200:
		s = StarA.instantiate()
		stars.append(s)
		add_child(s)
	for i in 30:
		s = StarB.instantiate()
		stars.append(s)
		add_child(s)
	for i in 5:
		_gen_cluster()

func _gen_cluster():
	var s
	var theta
	var r
	var dense = 100 + CALC._randint() % 400
	var starnum = 25 + CALC._randint() % 50
	var spot = Vector2(CALC._rand() * GLOBAL.resx,CALC._rand() * GLOBAL.resy)
	for i in starnum:
		theta = CALC._rand() * 2 * PI
		r = CALC._rand() * dense
		s = StarA.instantiate()
		stars.append(s)
		add_child(s)
		s.start_position = spot + Vector2(r * cos(theta),r * sin(theta))
	for i in round(starnum / 10):
		theta = CALC._rand() * 2 * PI
		r = CALC._rand() * dense
		s = StarB.instantiate()
		stars.append(s)
		add_child(s)
		s.start_position = spot + Vector2(r * cos(theta),r * sin(theta))

func _fadeset(dim):
	fadeset = dim
