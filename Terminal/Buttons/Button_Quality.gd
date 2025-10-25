extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	if(GLOBAL.graphics_quality == 2):
		text = "MEDIUM"
	elif(GLOBAL.graphics_quality == 3):
		text = "HIGH"
	elif(GLOBAL.graphics_quality == 1):
		text = "LOW"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	SFX._play_new([SFX.sound.BUTTON_ITEM])
	if(GLOBAL.graphics_quality == 1):
		GLOBAL.graphics_quality = 2
		text = "MEDIUM"
	elif(GLOBAL.graphics_quality == 2):
		GLOBAL.graphics_quality = 3
		text = "HIGH"
	elif(GLOBAL.graphics_quality == 3):
		GLOBAL.graphics_quality = 1
		text = "LOW"
	GLOBAL._save_settings()
