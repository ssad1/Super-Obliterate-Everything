class_name Explode_Hitbox
extends Area2D

var explosion
var inside_explosion:Array[Thing]
var expasion_duration:float = 0.5

func _ready() -> void:

	#avoid areas not detecting already-inside hitboxes immediatelly after instantiation
	_treat_immediate_areas()
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	explosion = get_parent()
	var collisionShape = get_node("CollisionShape2D")
	var fullsize = collisionShape.shape.radius * explosion.boom_scale * 6.5

	collisionShape.shape.radius = 0

	var tween = get_tree().create_tween()
	tween.tween_property(collisionShape.shape, "radius", fullsize, expasion_duration)

var tick_clock:float = 0
func _process(delta: float) -> void:

	#prevent weird behavior from stuff loaded outside of a match
	if explosion.inactive:
		explosion = null
		queue_free()
		return

	tick_clock = tick_clock + delta
	if tick_clock > 0.1:
		tick_clock = tick_clock - 0.1
		for target_unit in inside_explosion:
			target_unit.hit(explosion)
	if tick_clock > 0.2:
		tick_clock = 0.2

func _on_area_entered(area:Area2D) -> void:
	if not area is unit_hitbox: return

	var target_unit = (area as unit_hitbox).parent_unit

	if explosion.tcpu.check_target(target_unit):
		inside_explosion.append(target_unit)

func _on_area_exited(area:Area2D) -> void:

	if not area is unit_hitbox: return

	#hit logic

	var target_unit := (area as unit_hitbox).parent_unit

	if inside_explosion.has(target_unit):
		inside_explosion.erase(target_unit)

func _treat_immediate_areas() -> void:

	await get_tree().physics_frame

	var overlaps := get_overlapping_areas()
	for area in overlaps:
		_on_area_entered(area)
	