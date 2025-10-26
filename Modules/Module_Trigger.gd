extends Node2D

var up
var player
var offset_pos:Vector2 = Vector2(0.0,0.0)
var offset_radius:float = 0
var offset_rotate:float = 0
var pos:Vector2 = Vector2(0.0,0.0)
var rotate:float = 0
var velocity:Vector2 = Vector2(0.0,0.0)

var modules:Array = []
var is_type:String = "TRIGGER"

@export var death_activate:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up = get_parent()
	offset_pos = position
	offset_radius = sqrt(pow(offset_pos.x,2) + pow(offset_pos.y,2))
	offset_rotate = atan2(offset_pos.y, offset_pos.x) - PI/2
	up.modules.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	position = Vector2(-1 * offset_radius * sin(rotate + offset_rotate), offset_radius * cos(rotate + offset_rotate))

func _do_tick() -> void:
	rotate = up.rotate
	player = up.player
	pos = up.pos + offset_pos

func _fire() -> void:
	var s:Sprite2D = $Sprite2D
	s.frame = randi() % (s.hframes * s.vframes - 1)
	show()

func _on_death() -> void:
	var obj
	if death_activate == false: return
	for i in modules.size():
		if modules[i].has_method("_fire"):
			modules[i]._fire()
