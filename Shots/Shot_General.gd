extends Thing

@export var base_damage:float = 1
@export var force:float = 1
@export var damage_type:String = "KINETIC"

var clock:int = 0
var damage:float = 0
var lifespan:int = 20

@export var shot_scale:float = 1
@export var spin_mode:int = 0

func _ready() -> void:
	scale = shot_scale * Vector2(1,1)
	mat = get_material()
	_calc_damage()
	is_type = "SHOT"
	
	if mat != null && "set_shader_parameter" in mat:
		mat.set_shader_parameter("phase",randf() * 2 * PI)

	_do_range()

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

func _calc_damage() -> void:
	damage = round(base_damage * pow(1 + shot_scale,2) + 1)
	
func _do_tick() -> void:
	scale = shot_scale * Vector2(1,1)
	clock = clock + 1
	_calc_damage()
	if clock >= lifespan:
		armor = 0
	super._do_tick()

func _do_selection(delta:float) -> void:
	pass

func _set_player(p) -> void:
	if p != null:
		player = p
