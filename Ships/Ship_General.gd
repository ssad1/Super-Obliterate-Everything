class_name Ship_General
extends Thing

@export var thrust:float = 0
@export var aihigh:AI_Behavior.ai_high = AI_Behavior.ai_high.STANDART
@export var aistandoff:int = 100
@export var factory:SPAWNER.spawn_objs

var target_hot:bool = false
var target_pos:Vector2 = Vector2(0,0)
var base = null
var engine_burn:float = 0
var build_mission

@onready var is_halo:bool = aihigh == AI_Behavior.ai_high.HALO
@onready var has_burn:bool = has_node("Burn")
@onready var has_hull:bool = hull != null

var _ai_high:Callable
var _ai_mid:Callable
var _ai_low:Callable

var burn:Sprite2D
var ai:AI_Behavior

func _ready() -> void:
	inactive = false
	armor = max_armor
	is_type = UNIT_STATE.type.SHIP
	_do_range()
	UNIT_STATE.do_unit_build(self, build_speed)
	UNIT_STATE.do_unit_faction(self)
	UNIT_STATE.do_unit_frames(self)
	UNIT_STATE.do_unit_burn(self)
	UNIT_STATE.do_unit_light_bright(self)
	
	if has_burn: 
		burn = $Burn
		if !burn.visible: 
			burn.show()
	
	has_tcpu = tcpu != null
	ai = AI_Behavior.new(self)

func _add_payload(e,m,s) -> void:
	for module in modules:
		if module.name == "Module_Delivery":
			module.deliver_energy = e
			module.deliver_metal = m
			module.deliver_supply = s

func _init_center() -> void:
	target_pos = 0.5 * SPAWNER.game.mapsize
	rotate = atan2(pos.y - target_pos.y,pos.x - target_pos.x) - CALC.half_PI

func _ship_fix() -> void:
	if rotate >= TAU:
		rotate = rotate - TAU
	if rotate < 0:
		rotate = rotate + TAU
	rotation = 0

func _free_base() -> void:
	base = null

func _die() -> void:
	if base != null:
		base._remove_ship(spawn_id)
	super._die()

func _do_tick() -> void:
	super._do_tick()
	_do_ai()
	
func _process(delta:float) -> void:
	var blend_pos := position + (pos - position) * 0.1 + 0.2 * velocity
	set_position(blend_pos)
	_do_anim(delta)
	_do_selection(delta)

	if inactive: return

	tick_clock += delta# * tick_speed
	if tick_clock > 0.1:
		tick_clock -= 0.1
		_do_tick()
	if tick_clock > 0.2:
		tick_clock = 0.2
	
	physics_clock += delta
	if physics_clock > 0.1:
		physics_clock -= 0.1

		if is_not_struct: _do_physics()

	if physics_clock > 0.2:
		physics_clock = 0.2

func _do_anim(delta:float) -> void:

	if !has_hull: return

	var f:int
	_ship_fix()

	if !is_halo:
		f = floor(rotate * hull.hframes * hull.vframes / TAU)
		hull.frame = f

	if engine_burn > 0:
		engine_burn = engine_burn - delta
		engine_burn = clamp(engine_burn,0.0,1.0)

	if has_burn:

		if burn == null: return

		burn.frame = f
		burn.modulate = Color(1,0,0,engine_burn)

func _do_ai() -> void:
	if !has_tcpu: return
	if !is_instance_valid(self): return
	if spaghettified: return

	if armor <= 0:
		ai.aihigh = ai.ai_high.NONE
		ai.aimid = ai.ai_mid.NONE
		ai.ailow = ai.ai_low.NONE
		
	target_hot = false

	_ai_high.call()

	ai.d = 0.0
	ai.check_return = false

	_ai_mid.call()

	if ai.check_return && pos.x < -100 || \
	pos.x > SPAWNER.game.mapsize.x + 100 || \
	pos.y < -100 || \
	pos.x > SPAWNER.game.mapsize.y + 100:
		target_pos = ai.center
		ai.target_velocity = Vector2(0,0)
		ai.ailow = ai.ai_low.CHASE

	ai.facing_rotate = 0.0
	ai.target_rotate = 0.0
	ai.pos1 = Vector2(0,0)
	ai.theta = 0.0

	ai.thrust_dir = abs(CALC._rotate_direction(rotate,ai.theta))
	ai.thrust_vel = sqrt(pow(velocity.x,2) + pow(velocity.y,2))

	_ai_low.call()