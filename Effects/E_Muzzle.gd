extends Sprite2D

var up
var clock = 0
var alpha = 0
@export var spin = false

func _ready():
	up = get_parent()
	up.muzzle = self


func _process(delta):
	clock = clock + .5 * delta
	if(visible == true):
		if(alpha > 0):
			alpha = alpha - 2 * delta
			alpha = clamp(alpha,0,1)
		#modulate = Color(1,1,1,alpha)
	if(clock > .03):
		clock = clock - .03
		if(frame <= vframes * hframes - 2):
			frame = frame + 1
		else:
			frame = 0
		if(frame % hframes == 0):
			hide()

func _shoot(offset,theta):
	frame = randi() % vframes
	clock = 0
	position = offset
	rotation = theta
	if(spin == true):
		rotation = randf()*2*PI
	alpha = 1
	modulate = Color(1,1,1,alpha)
	show()
