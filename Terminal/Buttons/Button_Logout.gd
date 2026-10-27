extends Button

 

#func _process(delta:float) -> void:
#	pass

func _pressed():
	SFX._play_new([SFX.sound.BUTTON_START])
	EVENTS.emit_signal("clear_prizes",1)
	EVENTS.emit_signal("logout")
