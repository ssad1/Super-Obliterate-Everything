extends Node2D

@onready var E_TileFlip = preload("res://Effects/E_TileFlip.tscn")
var tiles = []

func _ready():
	var t
	var xx = 0
	var yy = 0
	var pos:Vector2
	var l
	EVENTS.connect("flipin", Callable(self, "_set_delays"))
	EVENTS.connect("flipout", Callable(self, "_set_delays"))
	EVENTS.connect("flipcomplete", Callable(self, "_flipcomplete"))
	for i in range(40):
		for j in range(23):
			t = E_TileFlip.instantiate()
			pos = Vector2(i * 49,j * 49)
			t.set_position(pos)
			tiles.append(t)
			add_child(t)
	_set_delays()
	hide()

#func _process(delta):
#	pass

func _flipin():
	EVENTS.emit_signal("flipin")

func _flipcomplete():
	hide()

func _set_delays():
	var boom = Vector2(randi() % GLOBAL.resx,randi() % GLOBAL.resy)
	var pos:Vector2
	var d = 0
	var d_max = 0
	var max_id = 0
	var speed_scale = 0.7
	print("FLIP")
	show()
	for i in range(tiles.size()):
		pos = tiles[i].position
		d = pos.distance_to(boom)
		tiles[i]._set_delay(speed_scale * d)
		if(d > d_max):
			d_max = d
			max_id = i
	tiles[max_id]._set_final()
