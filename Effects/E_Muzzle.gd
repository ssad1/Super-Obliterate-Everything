extends Sprite2D

var up
var clock:float = 0
var alpha:float = 0
@export var spin:bool = false

func _ready() -> void:
	up = get_parent()
	up.muzzle = self

func _process(delta:float) -> void:

	clock = clock + .5 * delta

	if visible && alpha > 0:
		alpha = alpha - 2 * delta
		alpha = clamp(alpha,0,1)

	if clock > 0.03:
		clock = clock - .03
		if frame <= vframes * hframes - 2:
			frame = frame + 1
		else:
			frame = 0
		if frame % hframes == 0:
			hide()

func _shoot(offset:Vector2, theta:float) -> void:
	frame = randi() % vframes
	clock = 0
	position = offset
	rotation = theta

	if spin:
		rotation = randf()*2*PI

	alpha = 1
	modulate = Color(1,1,1,alpha)
	show()
