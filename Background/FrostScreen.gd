extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_position(Vector2(.5 * GLOBAL.resx, .5 * GLOBAL.resy))
	hide()
	EVENTS.connect("froston", Callable(self,"_froston"))
	EVENTS.connect("flipload", Callable(self,"_flipload"))

func _froston():
	modulate = Color(.5,.5,.5,.15)
	show()

func _flipload():
	if(GLOBAL.nextscreen < 2):
		hide()
