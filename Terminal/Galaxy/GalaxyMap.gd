extends Node2D

@onready var center = Vector2(0,0)

var zoom = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("submenu_button_press", Callable(self, "_submenu_button_press"))
	set_position(Vector2(GLOBAL.resx / 2, GLOBAL.resy / 2 + 50))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(zoom < 1):
		zoom = zoom + 5 * delta
		if(zoom > 1):
			zoom = 1
		set_scale(Vector2(zoom,zoom))

func _ignite():
	var i
	zoom = 0.01
	set_scale(Vector2(zoom,zoom))

func _submenu_button_press(n):
	if(n == "Button_Galaxy"):
		_ignite()
		show()
	else:
		hide()
