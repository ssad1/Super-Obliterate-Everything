extends Light2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var clock = 0
@export var style = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clock = clock + delta
	match style:
		0:
			position.x = .5 * GLOBAL.resx + 150 * sin(clock / 5)
			energy = 10 + 5 * sin(clock / 2)
