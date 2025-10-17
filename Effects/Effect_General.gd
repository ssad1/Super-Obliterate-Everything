extends Node2D

var s = 0

var inertia = 0
var pos := Vector2(0.0,0.0)
var velocity := Vector2(0.0,0.0)
var rotate = 0
var rotate_velocity = 0
@export var lifespan = 1000.0
@export var effect_layer = 0
var clock = 0

var is_type = "EFFECT"
var spawn_id = 0
var dead = false

func _ready():
	for i in range(get_child_count()):
		if("emitting" in get_child(i)):
			get_child(i).emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clock = clock + delta
	_do_physics(delta)
	if(clock > lifespan):
		_die()

func _die():
	hide()
	queue_free()

func _do_physics(delta):
	pos = pos + delta * 10 * velocity
	rotate = rotate + delta * 10 * rotate_velocity
	if(rotate > TAU):
		rotate = rotate - TAU
	if(rotate < 0):
		rotate = rotate + TAU
	position = pos
	rotation = rotate
