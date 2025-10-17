extends Light2D

var anim = "WHITE"
var clock = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	clock = clock + delta
	match anim:
		"LIGHT RED":
			color = Color(1,.2,.2,1)
			energy = 10
		"RED":
			color = Color(1,.2,.2,1)
			energy = 20
		"FLASH":
			color = Color(1,1,1,1)
			energy = 6 * (.7 + .3 * sin(15 * clock))
