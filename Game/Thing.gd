class_name Thing
extends Node2D

@onready var tcpu_node = preload("res://Modules/TargetCPU.tscn")
@onready var FOV_node = preload("res://Modules/Target_FOV.tscn")
@onready var hull:Sprite2D = $Hull
@onready var mat:Material = $Hull.get_material()

var s
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
var pos:Vector2 = Vector2(0.0,0.0)
var velocity:Vector2 = Vector2(0.0,0.0)
var rotate:float = 0
var rotate_velocity:float = 0

@export var max_armor:float = 5
@export var max_shields:float = 0
var armor:float = 5
var shields:float = 0
var area_shield:float = 0
var max_area_shield:float = 0
var cloaked:bool = false
var range_radius:int = 100
var shield_radius:float = 0 #display only, set in area shield module

@export var target_profile:String = "NORMAL"
@export var special:String = ""
var guns_safety:bool = false

var burn_color = Color(1,0,0,1)
var light_bright:float = 1
var burn_bright:float = 0
var cloak_strength:float = 0
var freeze_strength:float = 0
var acid_strength:float = 0
var dissolve_strength:float = 0
var shock_strength:float = 0
var shield_strength:float = 0
var shield_damage:float = 0
var build_strength:float = 0
var swirl_strength:float = 0
var select_strength:float = 0
var offset:Vector2 = Vector2(randi() % 1000 + 10,randi() % 1000 + 10)

'''
var build_clock:float = 0
var build_max:float = 10
'''

var player
var tcpu:TargetCPU 
var tFOV
var hitbox
var phys
var stats

var ai_box = null
var modules = []
var spawn_id:int = 0
var dead:bool = false
var vanish:bool = false
var is_type:String = "THING"

@export var build_speed:float = 1

var _selection:bool
var is_selected:bool = false

func _ready() -> void:
	hide()
	_do_range()

func _add_tcpu() -> void:
	tcpu = tcpu_node.instantiate()
	tcpu.up = self
	tcpu.set_target_profile = target_profile

func _apply_force(f:float, dir:Vector2) -> void:
	var delta_v := Vector2(0,0)
	dir = dir.normalized()
	delta_v = inertia * f * dir
	velocity = velocity + delta_v

func _station_distance() -> float:
	var d := 10000.0
	var old_d := 10000.0

	for struct in player.my_structs:

		if struct.special == "STATION": continue

		d = pos.distance_to(struct.pos)

		if d < old_d:
			old_d = d

	return old_d

func _die() -> void:
	if stats != null:
		stats.hide()
		stats.queue_free()
		stats = null
	if vanish == false:
		for module in modules:
			if module.has_method("_on_death"):
				module._on_death()
	dead = true

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
	for module in modules:
		module._do_tick()

func _do_range() -> void:
	_add_tcpu()
	range_radius = 0
	for module in modules:
		if "gun_range" in module && module.gun_range > range_radius:
			range_radius = module.gun_range
		if "range_radius" in module && module.range_radius > range_radius:
			range_radius = module.range_radius
	
	tFOV = FOV_node.instantiate()
	add_child(tFOV)

	tFOV._initialize_FOV_area(range_radius)
	tFOV._bind_tcpu(tcpu)

func _do_shield_range() -> void:
	shield_radius = 0
	for module in modules:

		if "shield_radius" in module && module.shield_radius - module.shield_width / 2 > shield_radius:
			shield_radius = module.shield_radius - module.shield_width / 2
			area_shield = module.shield
			max_area_shield = module.max_shield

func _do_select(s:bool) -> void:
	is_selected = s
	if player != SPAWNER.game.me:
		is_selected = false

func _do_selection(delta:float) -> void:
	
	if is_selected:
		select_strength = 1
	elif select_strength > 0:
		select_strength = select_strength - 3 * delta
		select_strength = clamp(select_strength,0,1)

	mat.set_shader_parameter("select_strength",select_strength)

func _do_tick() -> void:

	if tcpu != null:
		tcpu._do_tick()

	if is_type != "STRUCT":
		_do_physics()

	if hitbox != null:
		hitbox._do_tick()

	_do_modules()
	_do_shield_range()

	if !visible:
		show()

	_set_stats()

	if armor <= 0:
		_die()

func _get_turret_score() -> int:
	var score := 0

	for module in modules:
		if module.is_type == "TURRET":
			score = score + module.tier

	return score

func _hit(s) -> void:
	armor = armor - s.damage

	if armor > max_armor:
		armor = max_armor

	UNIT_STATE.do_unit_damage_strength(self)

	if s.is_type == "SHOT":
		s.armor = 0
		_apply_force(s.force, s.velocity)
		SPAWNER._spawn_hit(s.damage_type, s.damage, s.pos, velocity, s.rotate)

	if s.is_type == "EXPLODE":
		_apply_force(s.force, s.pos.direction_to(pos))

	if s.is_type == "LASER":
		SPAWNER._spawn_hit(s.damage_type, s.damage, pos, velocity, s.rotate)

	if s.is_type == "MISSILE":
		s.armor = 0
		_apply_force(s.force, s.velocity)

func _process(delta:float) -> void:

	if stats == null && is_selected:
		stats = SPAWNER._spawn_stats()
		stats.set_position(position)
		_set_stats()

	if stats != null:
		if is_instance_valid(stats):
			stats.set_position(position)
		if is_selected == false:
			stats.queue_free()
			stats = null
	#if(global_position.x < -200 || global_position.x > GLOBAL.resx || global_position.y < -200 || global_position.y > GLOBAL.resy ):
	#	hide()
	#else:
	#	show()

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

func _set_stats() -> void:
	var a := 0.0
	var s := 0.0
	var sb := 0.0

	if !is_instance_valid(stats): return

	if armor > 0:
		if max_armor > 0:
			a = armor/max_armor
		else:
			a = 0
		if max_shields > 0:
			s = shields/max_shields
		else:
			s = 0
		if max_area_shield > 0:
			sb = area_shield/max_area_shield
		else:
			sb = 0
		stats._set_stats(a,s,sb,range_radius,shield_radius)
	else:
		stats.hide()
		stats.queue_free()
		stats = null
