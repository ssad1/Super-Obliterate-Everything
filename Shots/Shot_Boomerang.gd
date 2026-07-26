extends Shot_General

@onready var anim:AnimationPlayer = $AnimationPlayer
@export var acceleration:float
@export var detection_range:float

func _ready() -> void:

	if is_instance_valid(anim):
		anim.current_animation = "Spin"
	detection_range *= shot_scale
	_init_shot()

func _process(delta:float) -> void:
	var f:int
	var blend_pos := position + (pos - position) * .1 + .2 * velocity
	set_position(blend_pos)
	rotation = rotate

	if inactive: return

	_do_tick_clock(delta)

	physics_clock += delta
	if physics_clock > 0.1:
		physics_clock -= 0.1

		_do_physics()

	if physics_clock > 0.2:
		physics_clock = 0.2

func _do_tick() -> void:
	if clock >= lifespan:
		armor = 0

	_do_rebound()
	super._do_tick()

var vel_offset: Vector2 = velocity

func _do_rebound() -> void:
	var id := tcpu._target_closest(pos)
	if id <= -1: return

	var target = tcpu.targets[id]
	var vel_dot:float = target.velocity.normalized().dot((global_position - target.global_position).normalized())
	var dist:float = global_position.distance_to(target.global_position)

	if vel_dot < 0.8 && dist < detection_range:

		var velocity_coeff:Vector2 = (target.global_position - global_position).normalized()
		velocity = (vel_offset + velocity_coeff).normalized() * (velocity.length() * acceleration)