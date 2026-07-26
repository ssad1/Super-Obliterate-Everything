class_name Thing
extends Node2D

@export var name_text:String = "" 
@export var class_text:String = ""
@export var energy_cost:int = 0
@export var metal_cost:int = 0
@export var supply_cost:int = 0
@export var credit_cost:int = 1
@export var inertia:float = 0
@export var max_velocity:float = 0
@export var max_rotate_velocity:float = 0
@export var drag:float = 0
@export var max_armor:float = 5
@export var max_shields:float = 0
@export var target_profile:TargetCPU.profile = TargetCPU.profile.NORMAL
@export var scan_only_in_range:bool = false
@export var special:String = ""
@export var build_speed:float = 1

var pos:Vector2 = Vector2(0.0,0.0)
var velocity:Vector2 = Vector2(0.0,0.0)
var rotate:float = 0
var rotate_velocity:float = 0
var s
var armor:float = 5
var shields:float = 0
var area_shield:float = 0
var max_area_shield:float = 0
var cloaked:bool = false
var range_radius:int = 100
var shield_radius:float = 0 #display only, set in area shield module
var guns_safety:bool = false

var burn_color = Color(1,0,0,1)
var light_bright:float = 1
var burn_bright:float = 0

var spaghettified:bool = false
var select_strength:float = 0
var player:Player
var tcpu:TargetCPU 
var stats:Stats
var modules = []
var spawn_id:int = 0
var vanish:bool = false
var is_type:UNIT_STATE.type = UNIT_STATE.type.THING
var is_selected:bool = false
var inactive:bool = true 
var tick_clock:float = 0
var physics_clock:float = 0
var has_no_modules:bool = false

var tick_speed:float = 1.0:
	set(value):
		tick_speed = clampf(value, 0.0, 1.0)
	get:
		return tick_speed

var _death:bool = false
var dead:bool = _death:
	set(value):
		_do_death(value)

		_death = value
	get:
		return _death

@onready var hull:Sprite2D = $Hull
@onready var mat:Material = $Hull.get_material()
@onready var has_modules:bool = modules.size() > 0
@onready var has_tcpu:bool = tcpu != null
@onready var has_stats:bool = stats != null
@onready var is_not_struct:bool = is_type != UNIT_STATE.type.STRUCT

func _ready() -> void:
	_do_range()

func _process(delta:float) -> void:
	
	if inactive: return

	_do_tick_clock(delta)

	physics_clock += delta
	if physics_clock > 0.1:
		physics_clock -= 0.1

		if is_not_struct: _do_physics()

	if physics_clock > 0.2:
		physics_clock = 0.2

func _do_tick_clock(delta:float) -> void:

	if armor <= 0:
		die()

	tick_clock += delta * tick_speed

	if tick_clock > 0.1:
		tick_clock -= 0.1
		_do_tick()

	if tick_clock > 0.2:
		tick_clock = 0.2

func _add_tcpu() -> void:
	tcpu = TargetCPU.tcpu_node.instantiate()
	tcpu.up = self
	tcpu.set_target_profile = target_profile

func _apply_force(f:float, dir:Vector2) -> void:
	var delta_v := Vector2(0,0)
	dir = dir.normalized()
	delta_v = inertia * f * dir
	velocity = velocity + delta_v

func die() -> void:
	if vanish == false:
		for module in modules:
			if module.has_method("_on_death"):
				module._on_death()
	dead = true

func _do_death(value:bool) -> void:
	if value:
		var game_arr:Array = SPAWNER.game.get_thing_array(is_type)

		_remove_ref(spawn_id)
		queue_free()
		tree_exited.connect(func(): game_arr.erase(self))

func _do_physics() -> void:
	if sqrt(velocity.x * velocity.x + velocity.y * velocity.y) > max_velocity:
		velocity = velocity * 0.95

	velocity = velocity * (1.0 - drag)
	pos = pos + velocity

	if abs(rotate_velocity) > max_rotate_velocity:
		rotate_velocity = rotate_velocity * 0.95

	rotate = rotate + rotate_velocity

	if rotate > TAU:
		rotate = rotate - TAU

	if rotate < 0:
		rotate = rotate + TAU

func _do_modules() -> void:

	if has_no_modules: return

	shield_radius = 0
	for module in modules:

		if !is_instance_valid(module):
			has_no_modules = true
			return
		
		if "shield_radius" in module && module.shield_radius - module.shield_width / 2 > shield_radius:
			shield_radius = module.shield_radius - module.shield_width / 2
			area_shield = module.shield
			max_area_shield = module.max_shield
		
		module._do_tick()

func _do_range() -> void:
	_add_tcpu()
	range_radius = 0
	for module in modules:
		if "gun_range" in module && module.gun_range > range_radius:
			range_radius = module.gun_range
		if "range_radius" in module && module.range_radius > range_radius:
			range_radius = module.range_radius
	
	var tFOV = Target_FOV.FOV_node.instantiate()
	add_child(tFOV)

	tFOV._initialize_FOV_area(range_radius)
	tFOV._bind_tcpu(tcpu)

func _do_tick() -> void:

	if tcpu != null:
		tcpu._do_tick()

	if has_modules:
		_do_modules()

func _get_turret_score() -> int:
	var score := 0

	for module in modules:
		if module.is_type == UNIT_STATE.type.TURRET:
			score = score + module.tier

	return score

func do_damage(amount:float) -> void:
	armor = armor - amount

	if armor > max_armor:
		armor = max_armor

	UNIT_STATE.do_unit_damage(self)
	if stats != null: 
		stats.update_stats()
	
func hit(s) -> void:

	if s.is_type == UNIT_STATE.type.SINGULARITY:
		UNIT_STATE.do_black_hole_death(self)
		return
	
	do_damage(s.damage)
	UNIT_STATE.do_unit_damage_strength(self)

	#apply effects(Acid, freeze, shock, etc)

	if "shot_effects" in s:
		if s.shot_effects.size() == 0: return

		for effect in s.shot_effects:

			var instance:unit_effect = UNIT_STATE.effect[effect].new()

			instance.current_shot = s

			SPAWNER.game.add_child(instance)
			SPAWNER.game.unit_effects.append(instance)

			instance.apply_effect(self)

	if s.is_type == UNIT_STATE.type.SHOT:
		s.armor = 0
		_apply_force(s.force, s.velocity)
		SPAWNER._spawn_hit(s.damage_type, s.damage, s.pos, velocity, s.rotate)

	if s.is_type == UNIT_STATE.type.EXPLODE:
		_apply_force(s.force, s.pos.direction_to(pos))

	if s.is_type == UNIT_STATE.type.LASER:
		SPAWNER._spawn_hit(s.damage_type, s.damage, pos, velocity, s.rotate)

	if s.is_type == UNIT_STATE.type.MISSILE:
		s.armor = 0
		_apply_force(s.force, s.velocity)

func _remove_ref(s) -> void:
	if tcpu != null:
		tcpu._clean_target(s)
	for module in modules:
		if "_remove_ref" in module:
			module._remove_ref(s)

func _set_player(p) -> void:
	if p != null && hull != null:
		player = p
		var mat := hull.get_material()
		mat.set_shader_parameter("flag_color",player.flag_color)
		mat.set_shader_parameter("light_color",player.light_color)