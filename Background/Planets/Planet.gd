extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parallax = 1
var start_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _ignite(s):
	var scal
	parallax = randf() * 0.045 + 0.025
	if(s == 0): #Planet
		scal = .4 * randf() + .6
		$PlanetD.scale = Vector2(scal, scal)
	if(s == 1):
		scal = .4 * randf() + .6
		$PlanetD.scale = Vector2(scal, scal)
	start_position = Vector2(randf() * 1000 - 500,randf() * 1000 - 500)
	#start_position = Vector2(00,00)
	position = start_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = start_position - parallax * SPAWNER.game._cam_offset()
