extends Node2D

@export var applied_effects:Array[UNIT_STATE.effect_enum] = []
@export var effects_override:Array[Effect_Override]

var s
@export var damage:float = 10
@export var damage_type:String = "EXPLOSION"
@export var force:float = 5
@export var boom_radius:int = 0
@export var boom_flash:int = SPAWNER.spawn_objs.EFFECT_FLASH_BOOM
@export var boom_large_effect:int = SPAWNER.spawn_objs.EFFECT_BOOM
@export var boom_reverse:int = 0
@export var boom_scale:float = 1
@export var lifespan:int = 12
var clock:int = 0
var armor:float = 0
var is_type:UNIT_STATE.type = UNIT_STATE.type.EXPLODE

var death:bool = false
var dead:bool = death:
	set(value):
		if value:
			var game_arr:Array = SPAWNER.game.get_thing_array(is_type)

			_remove_ref(spawn_id)
			queue_free()
			tree_exited.connect(func(): game_arr.erase(self))

		death = value
	get:
		return death

var spawn_id:int = 0
var velocity:Vector2 = Vector2(0,0)
var pos:Vector2 = Vector2(0,0)
var rotate:float = 0
var modules = []
var tcpu:TargetCPU
var player
var debounce:bool = false
var tick_clock:float = 0
var inactive:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_tcpu()
	boom_reverse = lifespan - 5

func _process(delta:float) -> void:

	if inactive: return

	tick_clock += delta
	if tick_clock > 0.1:
		tick_clock -= 0.1
		_do_tick()
	if tick_clock > 0.2:
		tick_clock = 0.2

func _add_tcpu() -> void:
	tcpu = TargetCPU.tcpu_node.instantiate()
	tcpu.up = self
	tcpu.set_target_profile = tcpu.profile.EXPLOSION

func _boom() -> void:
	var pos_shift := Vector2(0,0)
	var r := 0
	var theta := 0.0
	var sc := 1.0
	var obj

	if clock == 1:
		obj = SPAWNER._spawn([boom_flash],null,pos,Vector2(0,0),0,0,0)
		obj.scale = Vector2(boom_scale/2,boom_scale/2)
		obj.modulate = Color(1,1,1,.5 + 1 * boom_scale)
	
	if clock <= lifespan - 5 and not debounce:
		debounce = true
		obj = SPAWNER._spawn([boom_large_effect],null,pos,Vector2(0,0),0,0,0)
		obj.scale = Vector2(boom_scale, boom_scale)

func _do_modules() -> void:
	for i in modules.size():
		modules[i]._do_tick()

func _do_tick() -> void:
	position = pos

	if tcpu != null:
		tcpu._do_tick()

	if clock < lifespan - 5:
		_boom()

	if clock == lifespan:
		dead = true

	if clock < boom_reverse:
		boom_radius = boom_radius + 16 * boom_scale
	else:
		boom_radius = boom_radius - 16 * boom_scale

	GLOBAL.heatbright = GLOBAL.heatbright + 2 * boom_scale
	clock = clock + 1

func _remove_ref(s) -> void:

	if tcpu != null:
		tcpu._clean_target(s)

	for i in modules.size():
		if "_remove_ref" in modules[i]:
			modules[i]._remove_ref(s)