extends Thing

@export var damage = 1
@export var damage_type = "KINETIC"
@export var force = 5.0
var clock = 0
var lifespan = 20
@export var shot_scale = float(1)

func _ready():
	scale = shot_scale * Vector2(1,1)
	is_type = "SHOT"
	_do_range()

func _process(delta):
	var blend_pos
	blend_pos = position + (pos - position) * .1 + .2 * velocity
	set_position(blend_pos)
	scale = shot_scale * Vector2(1,1)
	rotation = 0

func _do_tick():
	clock = clock + 1
	if(clock >= lifespan):
		armor = 0
	super._do_tick()

func _do_shader(delta):
	pass

func _set_player(p):
	var mat
	if(p != null):
		player = p
