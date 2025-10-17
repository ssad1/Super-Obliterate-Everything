extends VBoxContainer

var draft_id = 0
var draft_s = []

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("show_draft_buy", Callable(self,"_show_draft_buy"))
	EVENTS.connect("close_draft_buy", Callable(self,"_close_menu"))
	EVENTS.connect("submenu_button_press", Callable(self,"_close_menu_b"))
	EVENTS.connect("draft_buy", Callable(self,"_close_menu_c"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _close_menu():
	hide()

func _close_menu_b(s):
	_close_menu()

func _close_menu_c(p,i):
	_close_menu()

func _show_draft_buy(id,pos,s,n,c):
	draft_id = id
	var path := $PanelContainer/VBoxContainer

	path.get_node("Label_Item_Name").text = n
	path.get_node("Label_Item_Name/Label_Item_Name2").text = n
	path.get_node("Price/Label_Item_Price").text = str(c)
	
	global_position = pos + Vector2(32,32) - .5 * get_minimum_size()
	global_position.y = global_position.y - .25 * get_minimum_size().y
	show()
