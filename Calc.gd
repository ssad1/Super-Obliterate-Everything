extends Node

var rseed:int = 0

func _ready() -> void:
	pass # Replace with function body.

#func _process(delta):
#	pass

func _radian_distance(a:float, b:float) -> float:
	var t1 := 0.0
	var t2 := 0.0
	var d1 := 0.0
	var d2 := 0.0
	var d := 0.0
	a = _clamp_radians(a)
	b = _clamp_radians(b)

	if a < b:
		t1 = a
		t2 = b
	else:
		t1 = b
		t2 = a

	d1 = t2 - t1
	d2 = t1 + 2 * PI - t2

	if d1 < d2:
		d = d1
	else:
		d = d2

	return d

func _clamp_radians(r:float) -> float:
	while r > PI:
		r = r - 2 * PI
	while r < -1 * PI:
		r = r + 2 * PI
	return r

func _rand() -> float:
	rseed = (rseed*9301+49297) % 233280
	return rseed / 233280.0

func _randint() -> int:
	var n:int
	rseed = (rseed*9301+49297) % 233280
	n = round((rseed / 233280.0) * 1000000)
	return n

func _rotate_direction(a:float, b:float) -> float:

	var dir := 0.0
	var distance1 := 0.0
	var distance2 := 0.0

	if a < b:
		distance1 =  b - a
		distance2 = a + 2 * PI - b
		if distance1 < distance2:
			dir = distance1 - distance2 + 2 * PI
		if distance1 > distance2:
			dir = distance1 - distance2 - 2 * PI
			
	if a > b:
		distance1 =  a - b
		distance2 = b + 2 * PI - a
		if distance1 < distance2:
			dir = distance2 - distance1 - 2 * PI
		if distance1 > distance2:
			dir = distance2 - distance1 + 2 * PI

	dir = dir / (4 * PI)
	dir = dir * 2 * PI
	return dir
