class_name acid_effect
extends unit_effect

var damage_overtime = 1.0

#override the default values
func _init() -> void:
	tick_duration = 0.25

var fraction
func _on_effect() -> void:

	damage_overtime = current_shot.damage / (current_unit.armor/4) + 1
	duration = current_shot.damage * 5 * 100

	#acid graphics

	fraction = 6.0 / (damage_overtime * current_unit.armor)

	UNIT_STATE.do_unit_acid(current_unit, fraction)

func _on_effect_end() -> void:
	if not is_instance_valid(current_unit): return
	UNIT_STATE.do_unit_acid(current_unit, -fraction)

func _do_tick() -> void:

	if current_unit.armor - damage_overtime <= 0:
		disabled = true
		UNIT_STATE.do_unit_dissolve(current_unit, 1.5)
		queue_free()
		return

	current_unit.do_damage(damage_overtime)

func _on_unit_death() -> void:
	pass