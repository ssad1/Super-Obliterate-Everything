extends Node2D

var squares = []
var dimensions = Vector2(1,1)
var center = Vector2(0,0)
var buildability = false
var build_flag = 0
var builder

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var destroy = false
	_color_squares()
	if(weakref(builder).get_ref() == null):
		destroy = true
	else:
		if("is_type" in builder):
			if(builder.is_type == "SHIP"):
				if(builder.build_mission == null):
					destroy = true
			else:
				destroy = true
		else:
			destroy = true
	if(destroy == true):
		builder = null
		_clear_squares()
		queue_free()

func _clear_squares():
	for i in range(squares.size()):
		squares[i].queue_free()
	squares = []

func _ignite(b):
	var s
	var v = Vector2(1,1)
	var data
	_clear_squares()
	builder = b
	data = builder.build_mission
	#TODO Bug Invalid operands 'String' and 'Nil' in operator 'in'
	if("build_size" in SPAWNER.game.players[data[0]].item_bag_objs[data[2]]):
		v = SPAWNER.game.players[data[0]].item_bag_objs[data[2]].build_size
	else:
		v = SPAWNER.game.players[data[0]].item_bag_factory_objs[data[2]].build_size
	position = Vector2(32 * data[3], 32 * data[4])
	dimensions = v
	for i in range(v.x):
		for j in range(v.y):
			s = GLOBAL.SquareB.instantiate()
			add_child(s)
			s.set_position(Vector2(32 * i, 32 * j))
			squares.append(s)
	center = dimensions * 16

func _color_squares():
	var xx = 0
	var yy = 0
	var pos := Vector2(0,0)
	var building = true
	var light_color = "DIM"
	#Test Squares
	for i in range(squares.size()):
		pos = (squares[i].position + self.position) / 32
		if(int(pos.x) >= 0 && int(pos.x) < SPAWNER.game.radar.size() && int(pos.y) >= 0 && int(pos.y) < SPAWNER.game.radar.size()):
			if(SPAWNER.game.radar[int(pos.x)][int(pos.y)] != 1):
				squares[i].anim = "LIGHT RED"
			else:
				squares[i].anim = "RED"
				building = false
		else:
			squares[i].anim = "RED"
			building = false
	if(building == true):
		light_color = "DIM"
		for i in range(squares.size()):
			squares[i].anim = "DIM"
	else:
		light_color = "RED"
		for i in range(squares.size()):
			if(squares[i].anim == "FLASH"):
				squares[i].anim = "LIGHT RED"
	buildability = building

func _die():
	pass
