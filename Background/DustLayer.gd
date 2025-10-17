extends Node2D

@onready var DustA = preload("res://Background/DustA.tscn")

var dusts = []
var fade = 255
var fadeset = 255

func _ready():
	var s
	EVENTS.connect("flipload", Callable(self, "_flipload"))
	EVENTS.connect("fadeset", Callable(self, "_fadeset"))
	EVENTS.connect("duston", Callable(self, "_duston"))
	set_position(Vector2(0,0))	

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
	pass

func _flipload():
	if(GLOBAL.nextscreen == 0):
		_clear_dusts()
	if(GLOBAL.nextscreen == 1):
		_clear_dusts()
	if(GLOBAL.nextscreen == 2):
		#_clear_dusts()
		pass

func _clear_dusts():
	var i
	i = dusts.size() - 1
	while i > -1:
		dusts[i].queue_free()
		dusts.remove_at(i)
		i = i - 1

func _gen_dusts(a):
	var s
	for i in range(100):
		s = DustA.instantiate()
		dusts.append(s)
		add_child(s)

func _fadeset(dim):
	fadeset = dim

func _duston(a):
	_gen_dusts(a)
