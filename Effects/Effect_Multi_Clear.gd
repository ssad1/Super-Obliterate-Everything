extends "res://Effects/Effect_General.gd"

func _ready():
	pos = position
	rotate = rotation
	show()

#func _process(delta):
#	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	_die()
