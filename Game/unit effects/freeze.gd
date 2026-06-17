class_name freeze_effect
extends unit_effect

var freeze_strength = 0.0 #0-1, subtracts tick speed

static var gradient := preload("res://Effects/Gradients/Gradient_Freeze.tres")
static var primary_color := Color8(0,152,255,77)

#override the default values
func _init() -> void:
	has_no_tick = true

func _on_effect() -> void:
	freeze_strength = 1 #/ (current_unit.armor/2) * current_shot.damage
	duration = current_shot.damage * 3

	for effect in SPAWNER.game.unit_effects:

		#if we hit the same unit with another freeze, make the freeze with greater duration pass the duration to the other

		if not is_instance_valid(effect): continue

		if effect.get_script() == get_script() and effect.current_unit == current_unit:			
			duration = max(duration, effect.duration)
			effect.duration = duration
	
	current_unit.tick_speed -= freeze_strength
	UNIT_STATE.do_unit_freeze(current_unit, 1-current_unit.tick_speed)

func _on_effect_end() -> void:
	if not is_instance_valid(current_unit): return
	current_unit.tick_speed += freeze_strength
	UNIT_STATE.do_unit_freeze(current_unit, 1-current_unit.tick_speed)

static func do_shot_graphics(shot) -> void:
	if not shot is Shot_General: return
	shot.hull.modulate = primary_color

	shot.mat.set_shader_parameter("colors", gradient)
	shot.mat.set_shader_parameter("shimmer_strength", 0.1)
	shot.mat.set_shader_parameter("pulse_strength", 0.0)
	shot.mat.set_shader_parameter("frames", 1.0)