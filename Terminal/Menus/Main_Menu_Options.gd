extends HBoxContainer

var buttons = []
var submenus = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var name_text = ""
	for i in range(get_children().size()):
		name_text = get_child(i).name
		if(name_text.left(6) == "Button"):
			buttons.append(get_child(i))
		#if(name_text.left(6) == "Margin"):
		#	print("Adding Submenu")
		#	submenus.append(get_child(i).get_child(0))
	for i in range(buttons.size()):
		buttons[i].menu_id = i
		buttons[i].mode = 1
		#print(buttons[i].menu_id)
	#for i in range(submenus.size()):
	#	submenus[i].menu_id = i
	#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
