'''
THE NODE THAT TAKES CARE OF ALL THE SHADER STUFF REGARDING UNITS, FACTION COLORS, DAMAGE, ETC.
HAS ALL THE NECESSARY FUNCTIONS FOR ONLY THE NECESSARY SHADER PARAMETERS.
'''

extends Node

func do_unit_build(unit, duration:float) -> void:

	var mat:Material = unit.hull.get_material()

	get_tree().create_tween().tween_method(
		_set_build_strength.bind(mat),
		1.0,
		0.0,
		duration
	)

	mat.set_shader_parameter("build_strength",1)

func _set_build_strength(val:float, mat:Material) -> void:
	mat.set_shader_parameter("build_strength", val)

func do_unit_faction(unit) -> void:

	if unit.player == null: return

	var mat:Material = unit.hull.get_material()

	mat.set_shader_parameter("flag_color", unit.player.flag_color)
	mat.set_shader_parameter("light_color", unit.player.light_color)

func do_unit_frames(unit) -> void:
	var mat:Material = unit.hull.get_material()
	mat.set_shader_parameter("frames", Vector2(unit.hull.hframes, unit.hull.vframes))

func do_unit_burn(unit) -> void:
	var mat:Material = unit.hull.get_material()
	mat.set_shader_parameter("burn_color", unit.burn_color)
	mat.set_shader_parameter("burn_bright", unit.burn_bright)

func do_unit_light_bright(unit) -> void:
	var mat:Material = unit.hull.get_material()
	mat.set_shader_parameter("light_bright", unit.light_bright)

func do_unit_damage(unit) -> void:

	if unit.armor >= unit.max_armor: return

	var mat:Material = unit.hull.get_material()
	var strength:float = 1.0 - (unit.armor / unit.max_armor)

	#if unit.armor >= unit.max_armor:
	#	strength = 0

	mat.set_shader_parameter("burnt_strength", strength)
	mat.set_shader_parameter("fire_strength", strength)

func do_unit_damage_strength(unit) -> void:
	var mat:Material = unit.hull.get_material()

	get_tree().create_tween().tween_method(
		_set_damage_strength.bind(mat),
		1.0,
		0.0,
		0.6
	)

func _set_damage_strength(val:float, mat:Material) -> void:
	mat.set_shader_parameter("damage_strength", val)