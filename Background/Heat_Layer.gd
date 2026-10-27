extends ColorRect

var bright = 0.0

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	var brightb = 0
	if(GLOBAL.gamemode < 2):
		bright = 0
		GLOBAL.heatbright = 0
	if(bright <= GLOBAL.heatbright - 30 * delta):
		bright = bright + 30 * delta
	else:
		bright = GLOBAL.heatbright
	if(bright > GLOBAL.heatbright):
		bright = bright - 10 * delta
	bright = clamp(bright,0.0,100.0)
	brightb = bright - 20
	if(brightb > 0):
		modulate = Color(1,.1,.1,.0025 * brightb)
		show()
	else:
		hide()
