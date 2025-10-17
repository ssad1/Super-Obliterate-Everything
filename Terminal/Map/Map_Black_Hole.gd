extends Node2D

var speed = 0
@export var s = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = get_parent().speed + .04
	$AnimationPlayer.speed_scale = speed
