class_name acid_effect
extends unit_effect

var damage_overtime = 1.0
var fraction:float = 0.0
static var gradient := preload("res://Effects/Gradients/Gradient_Acid.tres")
static var primary_color := Color8(67,184,0,77)

#override the default values
func _init() -> void:
	tick_duration = 0.5

func do_unit_graphics(unit) -> void:
	fraction = 7.0 / (damage_overtime * unit.armor)
	UNIT_STATE.do_unit_acid(unit, fraction)

func _on_effect() -> void:

	damage_overtime = current_shot.damage / (current_unit.armor/4) + 0.5
	duration = current_shot.damage * 5

	#acid graphics

	do_unit_graphics(current_unit)

func _on_effect_end() -> void:
	if not is_instance_valid(current_unit): return
	UNIT_STATE.do_unit_acid(current_unit, -fraction)

func _do_tick() -> void:

	if current_unit.armor - damage_overtime <= 0:
		current_unit.vanish = true
		current_unit.burn_color = Color(0,0,0,0)
		has_no_tick = true
		UNIT_STATE.do_unit_dissolve(current_unit, 1.5)
		queue_free()
		return

	current_unit.do_damage(damage_overtime)

static func do_shot_graphics(shot) -> void:
	if not shot is Shot_General: return
	shot.hull.modulate = primary_color

	shot.mat.set_shader_parameter("colors", gradient)
