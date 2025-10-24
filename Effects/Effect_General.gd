extends Node2D

var s = 0

var inertia:float = 0
var pos:Vector2 = Vector2(0.0,0.0)
var velocity:Vector2 = Vector2(0.0,0.0)
var rotate:float = 0
var rotate_velocity:float = 0
@export var lifespan:int = 1000
@export var effect_layer:int = 0
var clock:int = 0

var is_type:String = "EFFECT"
var spawn_id:int = 0
var dead:bool = false

func _ready():
	for i in get_child_count():
		if "emitting" in get_child(i):
			get_child(i).emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	clock = clock + delta
	_do_physics(delta)
	if clock > lifespan:
		_die()

func _die() -> void:
	hide()
	queue_free()

func _do_physics(delta:float) -> void:
	pos = pos + delta * 10 * velocity
	rotate = rotate + delta * 10 * rotate_velocity
	if rotate > TAU:
		rotate = rotate - TAU
	if rotate < 0:
		rotate = rotate + TAU
	position = pos
	rotation = rotate
