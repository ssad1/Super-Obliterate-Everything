extends Control

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta:float) -> void:
#	pass

func _setup(s):
	$HBoxContainer/Credits.text = str(int(s))
