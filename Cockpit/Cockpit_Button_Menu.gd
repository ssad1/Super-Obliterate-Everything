extends "res://Terminal/Menu_Button.gd"


func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	SFX._play_new([SFX.sound.BUTTON_MENU])
	EVENTS.emit_signal("cancel_build")
	EVENTS.emit_signal("show_menu_options")
