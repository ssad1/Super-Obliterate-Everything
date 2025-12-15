extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	if(GLOBAL.graphics_shake == 0):
		text = "OFF"
	elif(GLOBAL.graphics_shake == 1):
		text = "ON"
	
	GLOBAL.shakes.append(self)

func _pressed():
	SFX._play_new([SFX.sound.BUTTON_ITEM])
	if(GLOBAL.graphics_shake == 0):
		GLOBAL.graphics_shake = 1
		text = "ON"
	elif(GLOBAL.graphics_shake == 1):
		GLOBAL.graphics_shake = 0
		text = "OFF"
	GLOBAL._save_settings()
	EVENTS.cam_shake.emit(text)
