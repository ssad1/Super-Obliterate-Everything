extends Node2D

var up
var player
var offset_pos:Vector2 = Vector2(0.0,0.0)
var offset_radius:float = 0
var offset_rotate:float = 0
var pos:Vector2 = Vector2(0.0,0.0)
var rotate:float = 0
var velocity:Vector2 = Vector2(0.0,0.0)

@export var deliver_energy:int = 0
@export var deliver_metal:int = 0
@export var deliver_supply:int = 0

var modules = []
var is_type:String = "TRIGGER"

@export var target_special:String = "STATION"

func _ready() -> void:
	up = get_parent()
	offset_pos = position
	offset_radius = sqrt(pow(offset_pos.x,2) + pow(offset_pos.y,2))
	offset_rotate = atan2(offset_pos.y, offset_pos.x) - PI/2
	up.modules.append(self)

func _process(delta:float) -> void:
	position = Vector2(-1 * offset_radius * sin(rotate + offset_rotate), offset_radius * cos(rotate + offset_rotate))

func _do_tick() -> void:
	rotate = up.rotate
	player = up.player
	pos = up.pos + offset_pos
	_check_delivery()

func _check_delivery() -> void:
	var t
	up.tcpu._clean_targets()
	for i in up.tcpu.targets.size():
		t = up.tcpu.targets[i]

		if (
		weakref(t) != null && 
		t.special == target_special && 
		pos.x > t.pos.x - 24 && 
		pos.x < t.pos.x + 24 && 
		pos.y > t.pos.y - 24 && 
		pos.y < t.pos.y + 24):
			_on_delivery()

func _on_delivery() -> void:
	if player == SPAWNER.game.me:
		SFX._play_new([4000])
	player._add_resource(deliver_energy, deliver_metal, deliver_supply)
	up.vanish = true
	up.armor = -100
	for i in modules.size():
		if modules[i].has_method("_fire"):
			modules[i]._fire()
