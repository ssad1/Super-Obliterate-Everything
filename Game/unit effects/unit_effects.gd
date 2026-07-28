class_name unit_effect
extends Node

var duration: float = 20.0 #in seconds
var tick_duration:float = 0.5 #in seconds 

var _current_tick:float = 0

var stackable: bool = true
var current_unit: Thing = null
var current_shot = null

var _disabled = false
var has_no_tick:bool = _disabled:
	set(value):
		_disabled = value
		set_process(!value)
	get:
		return _disabled

func _on_effect() -> void:
	pass

func _on_effect_end() -> void:
	pass

func _do_tick() -> void:
	pass

func do_unit_graphics(unit) -> void:
	pass

func apply_effect(unit:Thing) -> void:

	for effect in SPAWNER.game.unit_effects:

		#compare both effects to see if they are the same kind of effect, alongside their unit

		if not is_instance_valid(effect): continue

		if (effect.get_script() == get_script() and effect.current_unit == unit) and !stackable:
			queue_free()
			continue

	current_unit = unit
	_on_effect() 

func _finish_effect() -> void:

	has_no_tick = true
	_on_effect_end()
	queue_free()

func _process(delta:float) -> void:

	if current_unit == null: return

	if duration <= 0:
		_finish_effect()
		return

	duration -= delta

	_current_tick += delta
	if _current_tick > tick_duration:
		_current_tick = 0
		_do_tick()

static func do_shot_graphics(shot) -> void:
	pass