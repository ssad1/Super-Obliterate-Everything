extends Thing

@export var damage = 1
@export var damage_type = "KINETIC"
@export var force = 5.0
var clock = 0
var lifespan = 20
@export var shot_scale = float(1)

func _ready():
	scale = shot_scale * Vector2(1,1)
	is_type = UNIT_STATE.type.SHOT
	_do_range()

func _process(delta):

	var blend_pos
	blend_pos = position + (pos - position) * .1 + .2 * velocity
	set_position(blend_pos)
	scale = shot_scale * Vector2(1,1)
	rotation = 0

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

func _do_tick():
	clock = clock + 1
	if clock >= lifespan:
		armor = 0
	super._do_tick()

func _set_player(p):
	var mat
	if(p != null):
		player = p
