extends Sprite2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var s = CALC._rand() * 0.9 + .1
	var c = CALC._randint() % 100
	rotation = 2 * PI * CALC._rand()
	position = Vector2(CALC._rand() * GLOBAL.resx, CALC._rand() * GLOBAL.resy)
	s = .4 * pow(s, 3)
	if(CALC._rand() > 0.975):
		s = CALC._rand() * .5 + .5
	scale = Vector2(s,s)
	frame = CALC._randint() % (hframes * vframes)
	modulate = Color8(255,255 - c,255 - c,CALC._randint() % 75)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
