extends Node2D

@onready var tcpu_node = preload("res://Modules/TargetCPU.tscn")

var s
@export var damage = 10
#@export var damage_type = "EXPLOSION"
@export var force = 0
@export var boom_radius = 0
@export var boom_flash = SPAWNER.spawn_objs.EFFECT_FLASH_BOOM
@export var boom_effect = SPAWNER.spawn_objs.EFFECT_BOOM
@export var boom_smoke = SPAWNER.spawn_objs.EFFECT_BOOM
@export var boom_sparks = SPAWNER.spawn_objs.EFFECT_BOOM
@export var boom_scale = 1.0
@export var flash_scale = 1.0
@export var smoke_scale = 1.0
@export var sparks_scale = 1.0
var clock = 0
var armor = 0
@export var lifespan = 20
var is_type = "EXPLODE"
var dead = false
var spawn_id = 0
var velocity := Vector2(0,0)
var pos := Vector2(0,0)
var rotate = 0
var modules = []
var tcpu
var player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_tcpu()

func _add_tcpu():
	tcpu = tcpu_node.instantiate()
	tcpu.up = self
	tcpu.set_target_profile = "EXPLOSION"

func _boom():
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

func _do_modules():
	for i in range(modules.size()):
		modules[i]._do_tick()

func _do_tick():
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

func _remove_ref(s):
	if(tcpu != null):
		tcpu._clean_target(s)
	for i in range(modules.size()):
		if("_remove_ref" in modules[i]):
			modules[i]._remove_ref(s)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
