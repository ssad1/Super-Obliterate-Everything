class_name Stats
extends Node2D

var is_type:UNIT_STATE.type = UNIT_STATE.type.STATS
@onready var range_line:Line2D = $Range_Line
@onready var shield_line:Line2D = $Shield_Line
@onready var armor:Sprite2D = $Armor
@onready var armorback:Sprite2D = $ArmorBack
@onready var shield:Sprite2D = $Shield
@onready var shieldback:Sprite2D = $ShieldBack
@onready var areashield:Sprite2D = $AreaShield

var parent_unit
var draw_ranges:bool = false

static var stat_node = preload("res://Game/Stats/Stats.tscn")

func _ready() -> void:
	modulate = Color(1,1,1,0)
	range_line.scale = Vector2(.5,.5)
	shield_line.scale = Vector2(.5,.5)

	parent_unit = get_parent()
	#update_stats()

func do_fade(into: bool) -> void:
	var goal := into if 1.0 else 0.0
	get_tree().create_tween().tween_property(self, "modulate", Color(1,1,1,goal), 0.25)

	if !draw_ranges: return

	get_tree().create_tween().tween_property(range_line, "scale", Vector2(goal, goal), 0.25)
	get_tree().create_tween().tween_property(shield_line, "scale", Vector2(goal, goal), 0.25)

func _set_stats(armorValue:float, shieldValue:float, shieldBack:float, radius:float, shieldRadius:float) -> void:

	if draw_ranges:
		if radius > 0:
			_gen_circle(range_line,radius)
		else:
			range_line.clear_points()

		if shieldRadius > 0:
			_gen_circle(shield_line,shieldRadius)
		else:
			shield_line.clear_points()

	armor.scale = Vector2(armorValue,1)
	shield.scale = Vector2(shieldValue,1)
	areashield.scale = Vector2(shieldBack,1)
	armor.modulate = Color(1,0,0,1)

	if armorValue >= 0.33:
		armor.modulate = Color(1,.8,.4,1)

	if armorValue >= 0.66:
		armor.modulate = Color(1,1,1,1)

	shield.visible     = shieldValue  != 0
	areashield.visible = shieldBack != 0
	shieldback.visible = shieldValue != 0 || shieldBack != 0
	armor.visible      = armorValue != 0
	armorback.visible  = armorValue != 0

func update_stats() -> void:

	var max_armor:float       = parent_unit.max_armor
	var armor:float           = parent_unit.armor
	var max_shields:float     = parent_unit.max_shields
	var shields:float         = parent_unit.shields
	var max_area_shield:float = parent_unit.max_area_shield
	var area_shield:float     = parent_unit.area_shield
	
	var a := 0.0
	var s := 0.0
	var sb := 0.0

	if armor == 0: return

	if max_armor > 0:
		a = armor/max_armor
	else:
		a = 0
	if max_shields > 0:
		s = shields/max_shields
	else:
		s = 0
	if max_area_shield > 0:
		sb = area_shield/max_area_shield
	else:
		sb = 0

	_set_stats(a, s, sb, parent_unit.range_radius, parent_unit.shield_radius)

static func _gen_circle(l:Line2D, r:float) -> void:
	var theta := 0.0
	var samples := 0
	var p:Vector2
	l.clear_points()
	samples = round(TAU * r / 10)
	theta = 0
	for i in samples + 1:
		p = Vector2(r * sin(theta),r * cos(theta))
		l.add_point(p)
		theta = theta + TAU / samples

static func do_build_range(stat:Stats, radius:float, shieldRadius:float) -> void:

	var range_line = stat.get_node("Range_Line")
	var shield_line = stat.get_node("Shield_Line")

	range_line.scale = Vector2.ZERO
	shield_line.scale = Vector2.ZERO

	for i in stat.get_children():
		if i != range_line and i != shield_line:
			i.hide()

	if radius > 0:
		_gen_circle(range_line, radius)
	else:
		range_line.clear_points()

	if shieldRadius > 0:
		_gen_circle(shield_line, shieldRadius)
	else:
		shield_line.clear_points()

	stat.get_tree().create_tween().tween_property(range_line, "scale", Vector2(1, 1), 0.25)
	stat.get_tree().create_tween().tween_property(shield_line, "scale", Vector2(1, 1), 0.25)
