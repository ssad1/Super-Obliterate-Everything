extends Control

var alpha = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	EVENTS.connect("submenu_button_press",Callable(self,"_submenu_button_press"))

func _process(delta):
	if visible == true && alpha < 1:
		alpha = alpha + 3 * delta
		if alpha > 1:
			alpha = 1
		modulate = Color(1,1,1,alpha)

func _ignite():
	alpha = 0
	modulate = Color(1,1,1,alpha)
	show()

func _submenu_button_press(n):

	var received = n.substr(7, n.length() - 7)
	var current = name.substr(5, name.length() - 5)

	if received == current:
		_ignite()
		EVENTS.current_menu_selected = current
	else:
		hide()
		EVENTS.current_menu_selected = received