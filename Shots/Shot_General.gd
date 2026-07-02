class_name Shot_General
extends Thing

@export var base_damage:float = 1
@export var force:float = 1
@export var damage_type:String = "KINETIC"
@export var shot_scale:float = 1
@export var spin_mode:int = 0

@export var shot_effects:Array[UNIT_STATE.effect_enum] = []

var clock:int = 0
var damage:float = 0
var lifespan:int = 20

func _ready() -> void:
	_init_shot()

	#do the design of the rounds
	for effect in shot_effects:
		UNIT_STATE.effect[effect].do_shot_graphics(self)
		
func _init_shot():
	scale = Vector2(shot_scale, shot_scale)
	mat = get_material()
	_calc_damage()
	is_type = UNIT_STATE.type.SHOT
	
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
			self.frame = f

	if inactive: return

	tick_clock += delta
	if tick_clock > 0.1:
		tick_clock -= 0.1
		_do_tick()
	if tick_clock > 0.2:
		tick_clock = 0.2
	
	physics_clock += delta
	if physics_clock > 0.1:
		physics_clock -= 0.1

		_do_physics()

	if physics_clock > 0.2:
		physics_clock = 0.2

func _calc_damage() -> void:
	damage = round(base_damage * pow(1 + shot_scale,2) + 1)
	
func _do_tick() -> void:
	clock = clock + 1
	if clock >= lifespan:
		armor = 0
	super._do_tick()

func _do_selection(delta:float) -> void:
	pass

func _set_player(p) -> void:
	if p != null:
		player = p
