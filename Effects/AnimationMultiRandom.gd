extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var anims
	var i

	anims = get_animation_list()
	anims.erase("RESET")

	i = randi() % anims.size()
	play(anims[i])
