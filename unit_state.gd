'''
THE NODE THAT TAKES CARE OF ALL THE SHADER STUFF REGARDING UNITS, FACTION COLORS, DAMAGE, ETC.
HAS ALL THE NECESSARY FUNCTIONS FOR ONLY THE NECESSARY SHADER PARAMETERS.
NOW IT ALSO TAKES CARE OF THE UNIT'S TYPE FOR PERFORMANCE REASONS
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

func do_unit_build(unit, duration:float) -> void:

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

	if unit.armor >= unit.max_armor: return
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
		1.5
	)
	get_tree().create_tween().tween_property(unit, "scale", Vector2(0,0), 1.5).finished.connect(func(): unit._die())

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