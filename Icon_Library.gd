extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _get_icon(s):
	var obj
	for i in range(get_child_count()):
		if(get_child(i).name == s):
			obj = get_child(i).texture
			i = get_child_count()
	return obj
