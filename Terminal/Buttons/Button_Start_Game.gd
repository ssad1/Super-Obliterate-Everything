extends Button

 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta:float) -> void:
#	pass

func _pressed():
	SFX._play_new([SFX.sound.BUTTON_START])
	EVENTS.emit_signal("user_login",0)
