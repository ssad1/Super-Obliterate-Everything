extends Node2D

var speed = 0
@export var s = 0

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	speed = get_parent().speed + .04
	$AnimationPlayer.speed_scale = speed
