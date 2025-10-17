extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	if(GLOBAL.graphics_shake == 0):
		text = "OFF"
	elif(GLOBAL.graphics_shake == 1):
		text = "ON"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	SFX._play_new([4006])
	if(GLOBAL.graphics_shake == 0):
		GLOBAL.graphics_shake = 1
		text = "ON"
	elif(GLOBAL.graphics_shake == 1):
		GLOBAL.graphics_shake = 0
		text = "OFF"
	GLOBAL._save_settings()
