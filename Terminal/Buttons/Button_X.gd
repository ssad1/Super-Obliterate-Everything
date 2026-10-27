extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta:float) -> void:
#	pass

func _pressed():
	var a = get_parent()
	if a.name == "Menu_Items":
		EVENTS.emit_signal("show_menu_armory")
