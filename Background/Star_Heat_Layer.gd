extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("starheatset", Callable(self,"_star_heat_set"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(GLOBAL.gamemode < 2):
		hide()

func _star_heat_set(temp,light):
	modulate = light
	hide()
	match temp:
		"HOT":
			modulate.a = .05
			show()
		"VERY HOT":
			modulate.a = .1
			show()
		"INFERNO":
			modulate.a = .2
			show()
