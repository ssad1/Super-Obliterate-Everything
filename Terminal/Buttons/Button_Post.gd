extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	if(GLOBAL.graphics_post == 2):
		text = "MEDIUM"
	elif(GLOBAL.graphics_post == 3):
		text = "HIGH"
	elif(GLOBAL.graphics_post == 1):
		text = "LOW"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	if(GLOBAL.graphics_post == 1):
		GLOBAL.graphics_post = 2
		text = "MEDIUM"
	elif(GLOBAL.graphics_post == 2):
		GLOBAL.graphics_post = 3
		text = "HIGH"
	elif(GLOBAL.graphics_post == 3):
		GLOBAL.graphics_post = 1
		text = "LOW"
	GLOBAL._save_settings()
