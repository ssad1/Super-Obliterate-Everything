extends Control

var title_color = Color8(255,255,255,255)

func _ready():
	EVENTS.connect("flipload", Callable(self,"_flipload"))
	EVENTS.emit_signal("lightset", title_color, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _flipload():
	if(GLOBAL.nextscreen == 0):
		EVENTS.emit_signal("lightset", title_color, 1)
		show()
	if(GLOBAL.nextscreen == 1):
		hide()
	if(GLOBAL.nextscreen == 2):
		hide()
