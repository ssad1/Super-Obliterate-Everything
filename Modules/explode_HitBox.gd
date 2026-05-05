extends Area2D

var explosion
var inside_explosion:Array[Thing]

func _ready() -> void:
	explosion = get_parent()
	var collisionShape = get_node("CollisionShape2D")
	var fullsize = collisionShape.shape.radius * explosion.boom_scale * 6.5

	collisionShape.shape.radius = 0

	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	var tween = get_tree().create_tween()
	tween.tween_property(collisionShape.shape, "radius", fullsize, 0.5)

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

	#hit logic

	var target := area as unit_hitbox

	if not "is_type" in target: return

	var target_unit = target.parent_unit

	if explosion.tcpu.targets.has(target_unit):
		inside_explosion.append(target_unit)

func _on_area_exited(area:Area2D) -> void:

	if not area is unit_hitbox: return

	#hit logic

	var target := area as unit_hitbox

	if not "is_type" in target: return

	var target_unit := target.parent_unit

	if inside_explosion.has(target_unit):
		inside_explosion.erase(target_unit)
