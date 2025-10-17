extends Light2D

var v = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var pos:Vector2
	pos = position
	pos = pos + v * delta
	if(pos.x < 0):
		pos.x = 0
		v.x = -1 * v.x
	if(pos.x > GLOBAL.resx):
		pos.x = GLOBAL.resx
		v.x = -1 * v.x
	if(pos.y < 0):
		pos.y = 0
		v.y = -1 * v.y
	if(pos.y > GLOBAL.resy):
		pos.y = GLOBAL.resy
		v.y = -1 * v.y
	set_position(pos)

func _ignite():
	var t
	var r = randi() % 200
	set_position(Vector2(randi() % GLOBAL.resx, randi() % GLOBAL.resy))
	t = randf() * TAU
	v = Vector2(0,0)#Vector2(r * sin(t),r * cos(t))
