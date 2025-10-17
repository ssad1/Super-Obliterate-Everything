extends GPUParticles2D

var speed = 0

func _ready():
	pass

func _process(delta):
	speed = get_parent().speed
	speed_scale = speed
