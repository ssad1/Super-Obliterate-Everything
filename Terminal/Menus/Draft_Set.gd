extends VBoxContainer

var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("load_draft", Callable(self,"_load_draft"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _load_draft(fd):
	print("Draft Received " + str(id))
	if id < fd.size():
		$Item_Button._equip_item(fd[id])
		$Control/Price.text = str($Item_Button.obj.credit_cost)
