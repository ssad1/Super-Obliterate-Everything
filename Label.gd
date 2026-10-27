extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	text = str(int(Engine.get_frames_per_second()))
