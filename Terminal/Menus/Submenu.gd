extends HBoxContainer

var buttons = []
var menu_id = 0
var saved_button = 0

func _ready():
	var name_text = ""
	for i in range(get_children().size()):
		name_text = get_child(i).name
		if(name_text.left(6) == "Button"):
			buttons.append(get_child(i))
	for i in range(buttons.size()):
		buttons[i].menu_id = i
		buttons[i].mode = 2
	EVENTS.connect("menu_button_press", Callable(self, "_menu_button_pressed"))

func _process(delta):
	pass

func _menu_button_pressed(n):
	
	var received = n.substr(7, n.length() - 7)
	var current = name.substr(8, name.length() - 8)

	if(received == current):
		if(visible == false):
			show()
			buttons[saved_button].button_pressed = true
			buttons[saved_button]._pressed()
	else:
		hide()
