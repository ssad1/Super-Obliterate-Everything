extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta:float) -> void:
#	pass

func _pressed():
	EVENTS.emit_signal("close_draft_buy")
	SFX._play_new([SFX.sound.BUTTON_ITEM])
