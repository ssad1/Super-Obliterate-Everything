extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	SFX._play_new([SFX.sound.BUTTON_START])
	EVENTS.emit_signal("user_login",0)
