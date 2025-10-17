extends AnimationPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if(randf() > 0.5):
		speed_scale = randf() * .9 + .1
	else:
		speed_scale = -1 * (randf() * .9 + .1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
