extends Node2D

var up
var clock = 0
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
var alpha = 0
@export var spin = false

func _ready():
	up = get_parent()
	up.muzzle = self
	hide()
	anim.playback_active = false

func _process(delta):
	if(anim.playback_active == false):
		hide()
	else:
		show()

func _shoot(offset,theta):
	anim.playback_active = true
	anim.play("Burn")
	position = offset
	rotation = theta
	if(spin == true):
		rotation = randf()*2*PI
	show()
