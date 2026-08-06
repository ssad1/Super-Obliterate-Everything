extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(OS.get_screen_size())
	if(GLOBAL.graphics_maximized == true):
		text = "ON"
	elif(GLOBAL.graphics_maximized == false):
		text = "OFF"
	GLOBAL.fullscreens.append(self)

func _pressed():
	SFX._play_new([SFX.sound.BUTTON_ITEM])

	if(GLOBAL.graphics_maximized == true):
		GLOBAL._set_window()
		text = "OFF"
	elif(GLOBAL.graphics_maximized == false):
		GLOBAL._set_maximized()
		text = "ON"

	GLOBAL._save_settings()
	EVENTS.fullscreen.emit(text)
