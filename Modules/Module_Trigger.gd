extends Node2D

var up
var player
var offset_pos:Vector2 = Vector2(0.0,0.0)
var offset_radius:float = 0
var offset_rotate:float = 0
var pos:Vector2 = Vector2(0.0,0.0)
var rotate:float = 0
var velocity:Vector2 = Vector2(0.0,0.0)
var tick_clock:float = 0

var modules:Array = []
var is_type:UNIT_STATE.type = UNIT_STATE.type.TRIGGER

@export var death_activate:bool = false
var s:Sprite2D

func _ready() -> void:
	up = get_parent()
	offset_pos = position
	offset_radius = sqrt(pow(offset_pos.x,2) + pow(offset_pos.y,2))
	offset_rotate = atan2(offset_pos.y, offset_pos.x) - CALC.half_PI
	up.modules.append(self)

	if has_node("Sprite2D"): 
		s = $Sprite2D

func _process(delta:float) -> void:
	position = Vector2(-1 * offset_radius * sin(rotate + offset_rotate), offset_radius * cos(rotate + offset_rotate))

	#avoid making effects that affect tick speed messing up trigger modules
	if up.tick_speed < 1.0:
		_do_tick_clock(delta)

func _do_tick_clock(delta:float) -> void:

	tick_clock += delta

	if tick_clock > 0.1:
		tick_clock -= 0.1
		_do_tick()

	if tick_clock > 0.2:
		tick_clock = 0.2

func _do_tick() -> void:
	rotate = up.rotate
	player = up.player
	pos = up.pos + offset_pos

func _fire() -> void:
	s.frame = randi() % (s.hframes * s.vframes - 1)
	show()

func _on_death() -> void:
	#var obj
	if !death_activate: return
	for i in modules.size():
		if modules[i].has_method("_fire"):
			modules[i]._fire()
	#pass
