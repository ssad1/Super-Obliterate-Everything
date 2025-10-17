extends Control

# Called when the node enters the scene tree for the first time.

func _ready():
	EVENTS.connect("flipload", Callable(self,"_flipload"))
	EVENTS.connect("show_results", Callable(self,"_show_results"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _flipload():
	if(GLOBAL.nextscreen == 0):
		hide()
	if(GLOBAL.nextscreen == 1):
		hide()
	if(GLOBAL.nextscreen == 2):
		$Menu_Options.hide()
		show()

func _show_results(r):
	hide()
