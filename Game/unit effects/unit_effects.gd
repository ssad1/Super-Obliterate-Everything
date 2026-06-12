class_name unit_effect
extends Node

var duration: float = 100.0 #in seconds
var tick_duration:float = 0.5 #in seconds 

var _current_tick:float = 0

var stackable: bool = true
var current_unit: Thing = null

var _single_use = false
var single_use:bool = _single_use:
	set(value):
		_single_use = value
		set_process(!value)
	get:
		return _single_use

func _on_effect() -> void:
	pass

func apply_effect(unit:Thing) -> void:

	for effect in SPAWNER.game.unit_effects:

		#compare both effects to see if they are the same kind of effect, alongside their unit

		if (effect.get_script() == get_script() and effect.current_unit == unit) and !stackable:
			queue_free()
			return

	current_unit = unit
	_on_effect() 

func _do_tick() -> void:
	pass

func _ready() -> void:
	await get_tree().create_timer(duration).timeout
	queue_free()

func _process(delta:float) -> void:

	if current_unit == null: return

	_current_tick += delta
	if _current_tick > tick_duration:
		_current_tick = 0
		_do_tick()