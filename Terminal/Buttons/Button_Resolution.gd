extends Button

func _ready():
	text = str(str(GLOBAL.windowx) + "X" + str(GLOBAL.windowy))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	SFX._play_new([4006])
	_restext()
	
func _restext():
	if(GLOBAL.windowx == 1920):
		GLOBAL.windowx =  1280
		GLOBAL.windowy = 720
	elif(GLOBAL.windowx == 1280):
		GLOBAL.windowx = 1920
		GLOBAL.windowy = 1080
	text = str(str(GLOBAL.windowx) + "X" + str(GLOBAL.windowy))
	if(GLOBAL.graphics_maximized == false):
		GLOBAL._set_window()
	GLOBAL._save_settings()
