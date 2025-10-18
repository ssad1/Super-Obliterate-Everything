extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("submenu_button_press", Callable(self,"_submenu_button_press"))
	EVENTS.connect("draft_bought", Callable(self,"_draft_bought"))
	for i in range(get_child_count()):
		get_child(i).id = i


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _submenu_button_press(s):
	var fd
	if s == "Button_Draft":
		fd = DRAFT._gen_draft(0)
		show()
		EVENTS.emit_signal("load_draft", fd)

func _draft_bought():
	hide()
	for i in range(4):
		SPAWNER._spawn([10100], null, global_position + Vector2(randi() % 600,randi() % 250), Vector2(0,0), 0, 14, 0)
		SPAWNER._spawn([10101], null, global_position + Vector2(randi() % 600,randi() % 250), Vector2(0,0), 0, 14, 0)
