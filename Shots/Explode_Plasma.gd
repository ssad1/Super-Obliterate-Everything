extends Node2D

@onready var tcpu_node := preload("res://Modules/TargetCPU.tscn")

var s
@export var damage:float = 10
@export var damage_type = "EXPLOSION"
@export var force:float = 0
@export var boom_radius:float = 0
@export var boom_flash:int = SPAWNER.spawn_objs.EFFECT_PLASMA_FLASH
@export var boom_effect:int = SPAWNER.spawn_objs.EFFECT_PLASMA_BOOM
@export var boom_smoke:int = 0
@export var boom_sparks:int = 0
@export var boom_scale:float = 1
@export var flash_scale:float = 1
@export var smoke_scale:float = 1
@export var sparks_scale:float = 1
var clock:int = 0
var armor:float = 0
@export var lifespan:int = 20
var is_type:String = "EXPLODE"
var dead:bool = false
var spawn_id:int = 0
var velocity:Vector2 = Vector2(0,0)
var pos:Vector2 = Vector2(0,0)
var rotate:float = 0
var modules:Array = []
var tcpu:TargetCPU
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_tcpu()

func _add_tcpu() -> void:
	tcpu = tcpu_node.instantiate()
	tcpu.up = self
	tcpu.set_target_profile = "EXPLOSION"

func _boom() -> void:
	var obj
	if boom_flash != 0:
		obj = SPAWNER._spawn([boom_flash],null,pos,Vector2(0,0),0,0,0)
		obj.scale = Vector2(flash_scale,flash_scale)
	if boom_effect != 0:
		obj = SPAWNER._spawn([boom_effect],null,pos,Vector2(0,0),0,0,0)
		obj.scale = Vector2(boom_scale,boom_scale)
	if boom_smoke != 0:
		obj = SPAWNER._spawn([boom_smoke],null,pos,Vector2(0,0),0,0,0)
		obj.scale = Vector2(smoke_scale,smoke_scale)
	if boom_sparks != 0:
		obj = SPAWNER._spawn([boom_sparks],null,pos,Vector2(0,0),0,0,0)
		obj.scale = Vector2(sparks_scale,sparks_scale)

func _do_modules() -> void:
	for i in modules.size():
		modules[i]._do_tick()

func _do_tick() -> void:
	position = pos

	if clock == 0:
		_boom()

	if tcpu != null:
		tcpu._do_tick()
		
	_do_modules()
	if clock == lifespan:
		dead = true
	clock = clock + 1
	GLOBAL.heatbright = GLOBAL.heatbright + boom_scale

func _remove_ref(s) -> void:
	if tcpu != null:
		tcpu._clean_target(s)
	for i in modules.size():
		if "_remove_ref" in modules[i]:
			modules[i]._remove_ref(s)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
