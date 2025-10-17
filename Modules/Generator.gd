extends Node

var up
@export var energy_gen = 0.0
@export var metal_gen = 0.0
var is_type = "MODULE"

# Called when the node enters the scene tree for the first time.
func _ready():
	up = get_parent()
	up.modules.append(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _do_tick():
	if up.player != null:
		up.player._add_resource(energy_gen / 10, metal_gen / 10, 0)
