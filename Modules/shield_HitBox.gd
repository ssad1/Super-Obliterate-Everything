extends Node2D

@onready var deadzone:Area2D = $DeadZone
@onready var shieldHitBox:Area2D = $Area2D
@onready var parent_module = get_parent()

var culled_things:Array[Area2D] = []

func _ready() -> void:

	shieldHitBox.area_entered.connect(_shield_entered)
	deadzone.area_entered.connect(_deadzone_entered)
	deadzone.area_exited.connect(_deadzone_exited)

	var deadzoneShape = deadzone.get_node("CollisionShape2D")
	var hitboxShape = shieldHitBox.get_node("CollisionShape2D")

	hitboxShape.shape.radius = parent_module.shield_radius / 1.1
	deadzoneShape.shape.radius = parent_module.shield_width / 1.1

func _shield_entered(area:Area2D) -> void:
	if !_validate_collision(area): return
	if culled_things.has(area): return

	var parent_unit := (area as unit_hitbox).parent_unit

	parent_unit.armor = 0
	SPAWNER._spawn_hit("SHIELD", parent_unit.damage, parent_unit.pos, Vector2(0,0), parent_unit.rotate + PI)

	parent_module.Hit_shield(parent_unit.damage, parent_unit.pos)

func _deadzone_entered(area:Area2D) -> void:
	if !_validate_collision(area): return
	culled_things.append(area)

func _deadzone_exited(area:Area2D) -> void:
	if !culled_things.has(area): return
	culled_things.erase(area)

func _validate_collision(area:Area2D) -> bool:
	
	if parent_module.shield <= 0: return false

	if not area is unit_hitbox: return false

	var parent_unit := (area as unit_hitbox).parent_unit

	if !(SPAWNER.game.shots.has(parent_unit) || SPAWNER.game.missiles.has(parent_unit)): return false

	if (parent_unit.is_type == UNIT_STATE.type.LASER && parent_unit.is_type != UNIT_STATE.type.MISSILE) || \
		DIPLOMACY.grid[parent_unit.player.id][parent_module.up.player.id] != 0:
		return false

	return true
