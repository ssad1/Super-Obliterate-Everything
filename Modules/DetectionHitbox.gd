class_name unit_hitbox
extends Area2D

var pos:Vector2 = Vector2(0,0)
var is_type:UNIT_STATE.type = UNIT_STATE.type.MODULE
@onready var parent_unit:Thing
@export var parent_type := "DIRECT"

func _ready():
	'''
	if parent_type == "DIRECT":
		parent_unit = get_parent()
	elif parent_type == "SECONDARY":
		parent_unit = get_parent().get_parent()'''
	area_entered.connect(_on_area_entered)

func _on_area_entered(area:Area2D) -> void:

	#cull all the non-valid options
	if not area is unit_hitbox: return
	if not "is_type" in parent_unit: return

	#hit logic

	var target := area as unit_hitbox

	if not "is_type" in target: return

	var target_unit = target.parent_unit

	if ((SPAWNER.game.shots.has(target_unit) || 
		SPAWNER.game.missiles.has(target_unit)) &&
		target_unit.tcpu.targets.has(parent_unit)):
			parent_unit.hit(target_unit)