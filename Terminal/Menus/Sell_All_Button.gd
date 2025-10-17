extends Button

func _ready():
	EVENTS.connect("show_sell_button", Callable(self,"_show_sell_button"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	hide()
	EVENTS.emit_signal("sell_all")

func _show_sell_button():
	show()
