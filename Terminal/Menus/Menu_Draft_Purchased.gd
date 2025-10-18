extends Control

var draft

func _ready():
	EVENTS.connect("draft_bought", Callable(self, "_draft_bought"))

	draft = get_parent()

func _draft_bought():
	$AnimationPlayer.stop()
	show()
	$AnimationPlayer.play("New Anim")

func _done_animating():
	#print("Anim done")
	hide()

	#make sure we dont open the draft when we are already opening something else

	if EVENTS.current_menu_selected == draft.name.substr(5, draft.name.length() - 5):
		EVENTS.emit_signal("submenu_button_press", "Button_Draft")