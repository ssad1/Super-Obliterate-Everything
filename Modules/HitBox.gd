extends ColorRect

var pos:Vector2 = Vector2(0,0)
var is_type:String = "MODULE"
var parent_unit:Thing
@export var parent_type := "DIRECT"
@onready var detection_hitbox := $detection_hitbox

func _ready() -> void:

	#for ships and structs, ships are direct, structs are secondaries, basing the hitbox on their base instead

	if parent_type == "DIRECT":
		parent_unit = get_parent()
	elif parent_type == "SECONDARY":
		parent_unit = get_parent().get_parent()

	parent_unit.hitbox = self

	#setting up the detection hitbox

	var shape := detection_hitbox.get_node("CollisionShape2D")
	detection_hitbox.position = Vector2(size.x/2, size.y/2)
	detection_hitbox.parent_unit = parent_unit
	detection_hitbox.show()

	shape.shape.radius = size.y/1.5

	hide()

func _process(delta) -> void:
	var mp := get_global_mouse_position()
	var p := global_position
	var border := 10
	
	if parent_unit.visible:
		if mp.x < p.x + size.x + border && mp.x > p.x - border && mp.y < p.y + size.y +border && mp.y > p.y - border:
			parent_unit._do_select(true)
		else:
			parent_unit._do_select(false)

func _do_tick() -> void:
	pos = parent_unit.pos + position
