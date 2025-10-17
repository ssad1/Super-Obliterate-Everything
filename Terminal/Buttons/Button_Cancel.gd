extends Button

func _ready():
	pass # Replace with function body.

func _pressed():
	EVENTS.emit_signal("show_map")
