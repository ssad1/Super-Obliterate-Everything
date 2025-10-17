extends Node

#var inertia:float = 0
var pos:Vector2 = Vector2(0,0)
var velocity:Vector2 = Vector2(0,0)
var max_velocity:float = 0
var rotate:float = 0
var rotate_velocity:float = 0
var max_rotate_velocity:float = 0

#func _ready():
#	pass # Replace with function body.

#func _process(delta):
#	pass

func _do_tick():
	if sqrt(velocity.x * velocity.x + velocity.y * velocity.y) > max_velocity:
		velocity = velocity * 0.95
		
	pos = pos + velocity
	
	if abs(rotate_velocity) > max_rotate_velocity:
		rotate_velocity = rotate_velocity * 0.95

	rotate = rotate + rotate_velocity

	if rotate > TAU:
		rotate = rotate - TAU
	if rotate < 0:
		rotate = rotate + TAU
