extends Line2D

var connects = []
var distance_to_start = 0
var clock = 0
var bright_max = 100
var mission_a
var mission_b

func _ready():
	pass # Replace with function body.

func _process(delta):
	var c = 0
	clock = clock + delta
	c = 255 * (clock - .1 * (distance_to_start - 1))
	if(c > 255):
		c = 255
	if(c < 0):
		c = 0
	c = int(c * bright_max / 255)
	modulate = Color8(255,255,255,c)

func _draw_line(a,b):
	add_point(a.position + Vector2(16,16))
	add_point(b.position + Vector2(16,16))
	connects.append(a)
	connects.append(b)
	if(b.distance_to_start > a.distance_to_start):
		distance_to_start = a.distance_to_start
	else:
		distance_to_start = b.distance_to_start
	modulate = Color8(255,255,255,0)
	mission_a = a
	mission_b = b

func _set_lock():
	var locked = true
	if(ACCOUNT.mission_results[mission_a.id] == 1):
		locked = false
	if(ACCOUNT.mission_results[mission_b.id] == 1):
		locked = false
	if(locked == true):
		hide()
	else:
		show()
