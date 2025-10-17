extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("draft_bought", Callable(self, "_draft_bought"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draft_bought():
	$AnimationPlayer.stop()
	show()
	$AnimationPlayer.play("New Anim")

func _done_animating():
	print("Anim done")
	hide()
	EVENTS.emit_signal("submenu_button_press", "Button_Draft")
