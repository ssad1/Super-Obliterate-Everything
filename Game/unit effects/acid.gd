class_name acid_effect
extends unit_effect

var damage_overtime = 1.0

#TODO: do formula to calculate the damage/duration accordingly to previous shot status
func _on_effect() -> void:
	pass

func _do_tick() -> void:
	current_unit.do_damage(damage_overtime)