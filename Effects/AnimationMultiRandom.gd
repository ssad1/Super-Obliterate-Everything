extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var anims
	var i
	anims = get_animation_list()
	i = randi() % anims.size()
	play(anims[i],-1,1,false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
