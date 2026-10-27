extends Node

var grid:Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_grid("FFA")

func _setup_grid(s:String) -> void:
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
