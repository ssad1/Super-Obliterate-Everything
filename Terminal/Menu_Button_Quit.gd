extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	SFX._play_new([SFX.sound.BUTTON_START])
	GLOBAL.nextscreen = 1;
	EVENTS.emit_signal("clear_prizes",1)
	EVENTS.emit_signal("flipin")
