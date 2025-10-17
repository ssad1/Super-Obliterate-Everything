extends GPUParticles2D

var s
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.one_shot = true
	timer = get_node("Timer")
	timer.set_wait_time(3)
	timer.connect("timeout",self,"_timeout")
	timer.start()
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _timeout():
	self.hide()
	self.queue_free()
