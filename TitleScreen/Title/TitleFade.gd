extends ColorRect

var fadet = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	fadet = 0


func _process(delta):
	fadet = fadet + .5 * delta
	fadet = clamp(fadet,0,1.5)
	if(fadet > 0):
		modulate = Color(0,0,0,1 - (fadet - 0))
