extends Sprite2D

var clock = 0
var startframe = 0
var endframe = 0
var spin = 30
var dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var c = randf() * .9 + .1
	startframe = (randi() % (vframes - 1)) * hframes
	endframe = startframe + hframes
	frame = startframe + randi() % hframes
	modulate = Color(c,c,c,1)
	spin = 10 + randi() % 50
	if(randf() > 0.5):
		dir = -1 * dir

func _process(delta):
	clock = clock + spin * delta
	while(clock >= 1):
		if(dir == 1):
			if(frame < vframes * hframes - 1):
				frame = frame + 1
			else:
				frame = frame - hframes
			if(frame >= endframe):
				frame = frame - hframes
		else:
			if(frame > 0):
				frame = frame - 1
			else:
				frame = frame + hframes
			if(frame <= startframe):
				frame = frame + hframes
		clock = clock - 1
	
