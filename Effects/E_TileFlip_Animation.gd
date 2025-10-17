extends AnimationPlayer

var delay = 0
var delayclock = 0
var flipme = false
var flipmode = 0
var final = false

func _ready():
	EVENTS.connect("flipin", Callable(self, "_flipin"))
	EVENTS.connect("flipout", Callable(self, "_flipout"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(flipme == true):
		if(delayclock > 0):
			delayclock = delayclock - 1500 * delta
		elif(delayclock <= 0):
			if(flipmode == 0):
				play("FlipIn")
				get_owner().show()
			if(flipmode == 1):
				play("FlipOut")
			flipme = false
			delayclock = 0

func _flipin():
	flipmode = 0
	delayclock = delay
	flipme = true

func _flipout():
	flipmode = 1
	delayclock = delay
	flipme = true
