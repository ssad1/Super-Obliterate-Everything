extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(get_child_count()):
		get_child(i).id = i
		buttons.append(get_child(i))
	EVENTS.connect("setup_armory_items", Callable(self,"_setup_armory_items"))
	EVENTS.connect("submenu_button_press", Callable(self,"_button_press"))
	EVENTS.connect("menu_button_press", Callable(self,"_button_press"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _setup_armory_items():
	for i in buttons.size():
		buttons[i]._clear_obj()
	for i in buttons.size():
		buttons[i].item_id = ACCOUNT._get_item_id(i)
		if buttons[i].item_id != null:
			buttons[i]._equip_item(ACCOUNT.item_bag[buttons[i].item_id])

func _button_press(id):
	if(id == "Button_Equip" || id == "Button_Armory"):
		_setup_armory_items()
