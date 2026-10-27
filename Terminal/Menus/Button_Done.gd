extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta:float) -> void:
#	pass

func _pressed():
	EVENTS.emit_signal("submenu_button_press","Button_Conquest")
