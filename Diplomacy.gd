extends Node

var grid = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_grid("FFA")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _setup_grid(s):
	match s:
		"FFA":
			grid.append([2,1,1,1,1,1,1,1])
			grid.append([1,2,0,0,0,0,0,0])
			grid.append([1,0,2,0,0,0,0,0])
			grid.append([1,0,0,2,0,0,0,0])
			grid.append([1,0,0,0,2,0,0,0])
			grid.append([1,0,0,0,0,2,0,0])
			grid.append([1,0,0,0,0,0,2,0])
			grid.append([1,0,0,0,0,0,0,2])
