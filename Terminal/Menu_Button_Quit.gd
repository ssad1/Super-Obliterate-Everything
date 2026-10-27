extends Button

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta:float) -> void:
#	pass

func _pressed():
	SFX._play_new([SFX.sound.BUTTON_START])
	GLOBAL.nextscreen = 1;
	EVENTS.emit_signal("clear_prizes",1)
	EVENTS.emit_signal("flipin")
