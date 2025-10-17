extends Sprite2D

var anim = "WHITE"
var clock = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	clock = clock + delta
	match anim:
		"LIGHT RED":
			modulate = Color(1,.2,.2,.25)
		"RED":
			modulate = Color(1,.2,.2,1)
		"FLASH":
			modulate = Color(.7 + .3 * sin(15 * clock),.7 + .3 * sin(15 * clock),.7 + .3 * sin(15 * clock),.8)
		"DIM":
			modulate = Color(1,1,1,.5)
