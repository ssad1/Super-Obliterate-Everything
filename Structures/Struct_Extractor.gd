extends "res://Structures/Struct_General.gd"

var metal_storage = 0
@onready var anim = $Hull/AnimationPlayer

func _do_tick():
	if(anim != null):
		if(anim.speed_scale > 1):
			anim.speed_scale = anim.speed_scale - .5
			anim.speed_scale = clamp(anim.speed_scale,1,10)
		super._do_tick()

#func _process(delta):
#	pass

func _add_rock():
	anim.speed_scale = 10
	metal_storage = metal_storage + 1
