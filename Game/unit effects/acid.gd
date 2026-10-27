class_name acid_effect
extends unit_effect

var damage_overtime = null
var fraction:float = 0.0
static var gradient := preload("res://Effects/Gradients/Gradient_Acid.tres")
static var primary_color := Color8(67,184,0,77)

#override the default values
func _init() -> void:
	tick_duration = 0.5

func do_unit_graphics(unit) -> void:
	fraction = clampf((duration / 3.0) / (damage_overtime * unit.armor), 0.0, 1.0)
	UNIT_STATE.do_unit_acid(unit, fraction)

func _on_effect() -> void:

	duration = current_shot.damage * 5 if damage_overtime == null else duration
	damage_overtime = current_shot.damage / (current_unit.armor/4) + 0.5 if damage_overtime == null else damage_overtime

	#acid graphics

	do_unit_graphics(current_unit)

func _on_effect_end() -> void:
	if not is_instance_valid(current_unit): return
	UNIT_STATE.do_unit_acid(current_unit, -fraction)

func _do_dissolve(unit) -> void:
	SFX._play_new([SFX.sound.DISINTEGRATE])
	UNIT_STATE.do_unit_dissolve(current_unit, 1.5)

func _do_tick() -> void:

	if current_unit.armor - damage_overtime <= 0:
		current_unit.vanish = true
		current_unit.burn_color = Color(0,0,0,0)
		current_unit.has_stats = false

		if current_unit.has_node("detection_hitbox"):
			current_unit.get_node("detection_hitbox").monitoring = false
			current_unit.get_node("detection_hitbox").monitorable = false

		if "invulnerable" in current_unit: current_unit.invulnerable = true

		_do_dissolve(current_unit)
		set_process(false)
		queue_free()
		return

	current_unit.do_damage(damage_overtime)

static func do_shot_graphics(shot) -> void:
	if not shot is Shot_General: return
	shot.hull.modulate = primary_color

	shot.mat.set_shader_parameter("colors", gradient)
