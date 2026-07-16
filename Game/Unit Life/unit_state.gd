'''
THE NODE THAT TAKES CARE OF ALL THE SHADER STUFF REGARDING UNITS, FACTION COLORS, DAMAGE, ETC.
HAS ALL THE NECESSARY FUNCTIONS FOR ONLY THE NECESSARY SHADER PARAMETERS.
ALSO TAKES CARE OF THE UNIT'S TYPE FOR PERFORMANCE REASONS
'''

extends Node

enum type 
{
	STRUCT,
	TURRET,
	SHIP,
	MISSILE,
	SHOT,
	LASER,
	EXPLODE,
	EFFECT,
	STATS,
	THING,
	GUN,
	SHIELD,
	TRIGGER,
	HANGAR,
	MODULE,
	SINGULARITY,
}

enum effect_enum
{
	ACID,
	FREEZE
}

#contains references for the effect classes
var effect: Dictionary[effect_enum, Script] = {
	effect_enum.ACID: acid_effect,
	effect_enum.FREEZE: freeze_effect
}

func do_unit_build(unit, duration:float) -> void:

	if unit.mat == null: return

	get_tree().create_tween().tween_method(
		_set_build_strength.bind(unit.mat),
		1.0,
		0.0,
		duration
	)

	unit.mat.set_shader_parameter("build_strength",1)

func _set_build_strength(val:float, mat:Material) -> void:
	mat.set_shader_parameter("build_strength", val)

func do_unit_faction(unit) -> void:

	if unit.player == null: return

	unit.mat.set_shader_parameter("flag_color", unit.player.flag_color)
	unit.mat.set_shader_parameter("light_color", unit.player.light_color)

func do_unit_frames(unit) -> void:
	unit.mat.set_shader_parameter("frames", Vector2(unit.hull.hframes, unit.hull.vframes))

func do_unit_burn(unit) -> void:
	unit.mat.set_shader_parameter("burn_color", unit.burn_color)
	unit.mat.set_shader_parameter("burn_bright", unit.burn_bright)

func do_unit_light_bright(unit) -> void:
	unit.mat.set_shader_parameter("light_bright", unit.light_bright)

func do_unit_damage(unit) -> void:

	if unit.armor >= unit.max_armor || unit.mat == null: return
	var strength:float = 1.0 - (unit.armor / unit.max_armor)

	unit.mat.set_shader_parameter("burnt_strength", strength)
	unit.mat.set_shader_parameter("fire_strength", strength)

func do_unit_damage_strength(unit) -> void:

	if unit.is_type == UNIT_STATE.type.SHOT || unit.is_type == UNIT_STATE.type.LASER || unit.is_type == UNIT_STATE.type.SINGULARITY: return

	get_tree().create_tween().tween_method(
		_set_damage_strength.bind(unit.mat),
		1.0,
		0.0,
		0.6
	)

func _set_damage_strength(val:float, mat:Material) -> void:
	mat.set_shader_parameter("damage_strength", val)

func do_black_hole_death(unit) -> void:

	if unit.spaghettified: return
	unit.spaghettified = true

	get_tree().create_tween().tween_method(
		_set_swirl_strength.bind(unit.mat),
		0.0,
		0.5,
		3
	)
	get_tree().create_tween().tween_property(unit, "scale", Vector2(0,0), 1.5).finished.connect(
		_kill_unit.bind(unit)
	)

func _kill_unit(unit) -> void:
	if !is_instance_valid(unit): return
	if unit == null: return
	unit._die()

func _set_swirl_strength(val:float, mat:Material) -> void:
	mat.set_shader_parameter("swirl_strength", val)

func fade_stats(stat:Stats, from:float, to:float) -> void:
	get_tree().create_tween().tween_method(
		_set_build_strength.bind(stat),
		from,
		to,
		1
	)

func _set_stat_modulate(val:float, stat:Stats) -> void:
	stat.modulate.a = val
	stat.range_line.scale = Vector2(.5 + .5 * val,.5 + .5 * val)
	stat.shield_line.scale = Vector2(1.2 - .2 * val,1.2 - .2 * val)

func do_unit_acid(unit, amount:float) -> void:

	if unit.mat == null: return

	var current:float = unit.mat.get_shader_parameter("acid_strength")

	get_tree().create_tween().tween_method(
		_set_acid.bind(unit.mat),
		current,
		current + amount,
		1
	)

func _set_acid(val:float, mat:Material) -> void:
	mat.set_shader_parameter("acid_strength", val)

func do_unit_dissolve(unit, duration:float) -> void:

	if unit.mat == null: return

	await get_tree().create_tween().tween_method(
		_set_corrode.bind(unit.mat),
		0.0,
		1.5,
		duration
	).finished

	if not is_instance_valid(unit): return
	unit.armor = 0

func _set_corrode(val:float, mat:Material) -> void:
	mat.set_shader_parameter("dissolve_strength", val)

func do_unit_freeze(unit, amount:float) -> void:

	if unit.mat == null: return

	var current:float = unit.mat.get_shader_parameter("freeze_strength")

	get_tree().create_tween().tween_method(
		_set_freeze.bind(unit.mat),
		current,
		amount,
		1
	)

func _set_freeze(val:float, mat:Material) -> void:
	mat.set_shader_parameter("freeze_strength", val)

func do_unit_select(unit, selected:bool) -> void:

	if unit.mat == null: return

	var current:float = unit.mat.get_shader_parameter("select_strength")
	var goal:int = selected if 1 else 0

	get_tree().create_tween().tween_method(
		_set_select.bind(unit.mat),
		current,
		goal,
		0.5
	)

func _set_select(val:float, mat:Material) -> void:
	mat.set_shader_parameter("select_strength", val)