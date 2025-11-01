extends Shot_General

@onready var anim:AnimationPlayer = $AnimationPlayer

func _ready() -> void:

	if is_instance_valid(anim):
		anim.current_animation = "Spin"
	_init_shot()

func _process(delta:float) -> void:
	var blend_pos:Vector2
	var f:int
	blend_pos = position + (pos - position) * .1 + .2 * velocity
	set_position(blend_pos)
	match spin_mode:
		0:
			rotation = rotate
		1:
			rotation = 0
			f = floor(rotate * self.hframes * self.vframes / (2 * PI))
			self.frame = f
