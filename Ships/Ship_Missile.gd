class_name Ship_Missile
extends Ship_General

@export var lifespan:int = 20
@export var detonate_range:int = 16
var missile_clock:int = 0
@export var shot_scale:float = 1
@export var damage:float = 1
@export var force:float = 1
@export var smoke_trail:SPAWNER.spawn_objs = 0

func _ready() -> void:
	scale = shot_scale * Vector2(1,1)
	armor = max_armor
	is_type = UNIT_STATE.type.MISSILE
	_do_range()
	has_tcpu = tcpu != null
	ai = AI_Behavior.new(self)

func _process(delta:float) -> void:
	if inactive: return
	var blend_pos := position + (pos - position) * 0.1 + 0.2 * velocity
	set_position(blend_pos)
	_do_anim(delta)
	
	_do_tick_clock(delta)

	physics_clock += delta
	if physics_clock > 0.1:
		physics_clock -= 0.1

		_do_physics()

	if physics_clock > 0.2:
		physics_clock = 0.2

func _do_tick() -> void:
	missile_clock = missile_clock + 1
	if missile_clock >= lifespan:
		armor = -100
	
	super._do_tick()

func _do_smoke() -> void:
	var offset := Vector2(0,0)
	var obj
	if smoke_trail != 0:
		offset.x = -16 * sin(rotate)
		offset.y = 16 * cos(rotate)
		obj = SPAWNER._spawn([smoke_trail], null, position + offset, Vector2(0,0),0,0,0)
		obj.scale = Vector2(0.6, 0.6) * shot_scale
		obj.scale = Vector2(0.6, 0.6) * shot_scale