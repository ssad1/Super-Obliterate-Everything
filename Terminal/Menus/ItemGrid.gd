extends GridContainer

@onready var buttons = []
var sorted_item_bag = []
var reload_clock = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("setup_items", Callable(self,"_setup_items"))
	EVENTS.connect("submenu_button_press", Callable(self,"_submenu_button_press"))
	EVENTS.connect("sell_all", Callable(self,"_sell_all"))
	_setup_buttons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(reload_clock > 0):
		reload_clock = reload_clock - delta
		if(reload_clock <= 0):
			reload_clock = 0
			_setup_items(0)
			EVENTS.emit_signal("show_sell_button")

func _calc_price():
	var total_price = 0
	if(get_parent().get_parent().name == "Menu_Sell"):
		for i in range(buttons.size()):
			if(weakref(buttons[i].obj).get_ref() != null):
				if(buttons[i].button_pressed == true):
					total_price = total_price + buttons[i].obj.credit_cost
	return total_price

func _sort_a(a,b):
	if(a[1] < b[1]):
		return true
	return false

func _setup_items(id):
	if(get_parent().get_parent().visible == true):
		_setup_sorted()
		for i in buttons.size():
			buttons[i]._clear_obj()
		for i in buttons.size():
			if i+id < sorted_item_bag.size():
				buttons[i].item_id = sorted_item_bag[i+id][0]
				buttons[i]._equip_item(sorted_item_bag[i + id].slice(1,100))

func _setup_sorted():
	var a_items = []
	var j = 0
	sorted_item_bag = []
	a_items = ACCOUNT.item_bag
	for i in range(a_items.size()):
		if(a_items[i] != null):
			sorted_item_bag.append([i] + a_items[i])
	sorted_item_bag.sort_custom(Callable(self,"_sort_a"))

func _setup_buttons():
	buttons = []
	for i in range(get_child_count()):
		buttons.append(get_child(i))
		buttons[i].id = i

func _submenu_button_press(s):
	if(s == "Button_View" && get_parent().get_parent().visible == true):
		_setup_items(0)
	if(s == "Button_Sell" && get_parent().get_parent().visible == true):
		_setup_items(0)

func _sell_all():
	if(get_parent().get_parent().name == "Menu_Sell"):
		for i in range(buttons.size()):
			if(buttons[i].button_pressed == true):
				buttons[i]._sell()
	ACCOUNT._save_game()
	reload_clock = .5

func _page_flip(p):
	_setup_items(p * 100)
