'''
THE NODE THAT TAKES CARE OF ALL THE SHADER STUFF REGARDING UNITS, FACTION COLORS, DAMAGE, ETC.
HAS ALL THE NECESSARY FUNCTIONS FOR ONLY THE NECESSARY SHADER PARAMETERS.
'''

extends Node

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

	if unit.is_type == "SHOT" || unit.is_type == "LASER": return

	get_tree().create_tween().tween_method(
		_set_damage_strength.bind(unit.mat),
		1.0,
		0.0,
		0.6
	)

func _set_damage_strength(val:float, mat:Material) -> void:
	mat.set_shader_parameter("damage_strength", val)
