extends Explode_Hitbox

func _ready() -> void:
	expasion_duration = 2
	super._ready()

func _on_area_entered(area:Area2D) -> void:
	if not area is unit_hitbox: return

	var target_unit = (area as unit_hitbox).parent_unit

	if not TargetCPU.is_target_eligible(explosion, target_unit.is_type): return

	_apply_effects(target_unit)

func _on_area_exited(area:Area2D) -> void:
	pass

func _treat_immediate_areas() -> void:

	await get_tree().physics_frame

	var overlaps := get_overlapping_areas()
	for area in overlaps:
		_on_area_entered(area)
	
func _apply_effects(unit) -> void:

	for effect in explosion.applied_effects:
		var instance:unit_effect = UNIT_STATE.effect[effect].new()

		instance.current_shot = explosion

		SPAWNER.game.add_child(instance)
		SPAWNER.game.unit_effects.append(instance)

		_do_overrides(effect, instance)

		instance.apply_effect(unit)
		instance.do_unit_graphics(unit)

#make we be able to balance stuff properly. be able to set any property we want in-editor
func _do_overrides(effect_enum:UNIT_STATE.effect_enum, effect_instance:unit_effect) -> void:
	for override in explosion.effects_override:
		if override.overrided_effect != effect_enum: continue
		if not override.property in effect_instance: continue
		effect_instance[override.property] = override.value
