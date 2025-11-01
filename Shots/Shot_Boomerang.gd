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
	match spin_mode:
		0:
			rotation = rotate
		1:
			rotation = 0
			f = floor(rotate * self.hframes * self.vframes / (2 * PI))
			self.frame = f

func _do_tick() -> void:
	clock = clock + 1
	if clock >= lifespan:
		armor = 0

	_do_rebound()
	super._do_tick()

var vel_offset: Vector2 = velocity

func _do_rebound() -> void:
	var id := tcpu._target_closest(pos)
	if id <= -1: return

	var target = tcpu.targets[id]
	var to_target:Vector2 = (target.pos - pos).normalized()
	var dist = pos.distance_to(target.pos)

	if dist < detection_range:

		var velocity_coeff: Vector2 = to_target * acceleration
		velocity = (vel_offset + velocity_coeff).normalized() * velocity.length()