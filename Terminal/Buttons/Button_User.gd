extends Button

@onready var userid = 0

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func _pressed():
	EVENTS.emit_signal("user_login",userid)
