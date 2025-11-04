class_name unit_hitbox
extends Area2D

var pos:Vector2 = Vector2(0,0)
var is_type:UNIT_STATE.type = UNIT_STATE.type.MODULE
@onready var parent_unit:Thing
 
func _ready():
	#area_entered.connect(_on_area_entered)
	pass


func _on_area_entered(area:Area2D) -> void:

	#cull all the non-valid options
	if not area is unit_hitbox: return
	if not "is_type" in parent_unit: return

	#hit logic

	var target := area as unit_hitbox

	if not "is_type" in target: return
	if target.parent_unit == parent_unit: return

	if (
		parent_unit.is_type == UNIT_STATE.type.SHOT || 
		parent_unit.is_type == UNIT_STATE.type.MISSILE && 
		parent_unit.tcpu.targets.has(target.parent_unit)
	   ):
			target.parent_unit._hit(parent_unit)