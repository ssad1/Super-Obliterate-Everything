extends Button

var price = 0
var item = []

func _ready():
	EVENTS.connect("show_draft_buy", Callable(self,"_show_draft_buy"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	print(price)
	if(ACCOUNT.credits >= price):
		EVENTS.emit_signal("draft_buy",price,item)
		SFX._play_new([2001])
	else:
		EVENTS.emit_signal("draft_error", "POOR")
		SFX._play_new([4007])

func _show_draft_buy(id,pos,s,n,c):
	price = c
	item = s
