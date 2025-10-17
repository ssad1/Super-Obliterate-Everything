extends GridContainer

var item_buttons = []
var fade_in = false
var fade_alpha = 1

func _ready():
	EVENTS.connect("equip", Callable(self,"_equip"))
	EVENTS.connect("cancel_build", Callable(self,"_cancel_build"))
	EVENTS.connect("new_build_spot", Callable(self, "_new_build_spot"))
	item_buttons = []
	for i in range(get_child_count()):
		get_child(i).id = i
		item_buttons.append(get_child(i))

		var key := OS.get_keycode_string(KEYMAPS.BuildGrid[i])

		item_buttons[i].hotkey.text = "["+key+"]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(fade_in == true):
		fade_alpha = fade_alpha + 5 * delta
		if(fade_alpha >= 1):
			fade_alpha = 1
			fade_in = false
	modulate = Color(1,1,1,fade_alpha)

func _equip(bag):
	for i in range(item_buttons.size()):
		item_buttons[i]._clear_obj()
	#Skip a space for station item
	for i in range(1,bag.size(),1):
		if(bag[i] != null):
			print("Equipping ", i, " ", bag[i])
			item_buttons[i-1]._equip_item(bag[i])

func _new_build_spot(a,b,c,d,e,f):
	hide()
	fade_in = false
	fade_alpha = 0
	modulate = Color(1,1,1,fade_alpha)

func _cancel_build():
	if(visible == false):
		fade_in = true
		modulate = Color(1,1,1,fade_alpha)
		show()
