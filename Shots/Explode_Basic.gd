extends Node2D

@onready var tcpu_node = preload("res://Modules/TargetCPU.tscn")

var s
@export var damage:float = 10
@export var damage_type:String = "EXPLOSION"
@export var force:float = 5
@export var boom_radius:int = 0
#@export var boom_max_radius:int = 0
#@export var boom_intensity = 0
@export var boom_flash:int = SPAWNER.spawn_objs.EFFECT_FLASH_BOOM
#@export var boom_small_effect:int = 10300
#@export var boom_medium_effect:int = 10302
@export var boom_large_effect:int = SPAWNER.spawn_objs.EFFECT_BOOM
@export var smoke_effect:int = SPAWNER.spawn_objs.EFFECT_SMOKE
@export var boom_reverse:int = 0
@export var boom_scale:float = 1
var clock:int = 0
var armor:float = 0
var lifespan:int = 12
var is_type:String = "EXPLODE"
var dead:bool = false
var spawn_id:int = 0
var velocity:Vector2 = Vector2(0,0)
var pos:Vector2 = Vector2(0,0)
var rotate:float = 0
var modules = []
var tcpu:TargetCPU
var player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_tcpu()
	boom_reverse = lifespan - 5

func _add_tcpu() -> void:
	tcpu = tcpu_node.instantiate()
	tcpu.up = self
	tcpu.set_target_profile = "EXPLOSION"

func _boom() -> void:
	var pos_shift := Vector2(0,0)
	var r := 0
	var theta := 0.0
	var sc := 1.0
	var obj

	if clock == 1:
		obj = SPAWNER._spawn([boom_flash],null,pos,Vector2(0,0),0,0,0)
		obj.scale = Vector2(1.5 * boom_scale,1.5 * boom_scale)
		obj.modulate = Color(1,1,1,.5 + 1 * boom_scale)
	
	if boom_scale > 1:
		for i in round(boom_scale * 2):
			theta = randf() * 2 * PI
			r = randf() * boom_radius
			pos_shift = Vector2(r * sin(theta),r * cos(theta))
			obj = SPAWNER._spawn([boom_large_effect],null,pos + pos_shift,Vector2(0,0),0,0,0)
			sc = (randf() * 0.7) + 0.2
			obj.scale = Vector2(sc, sc)
	
	if clock <= lifespan - 5:
		obj = SPAWNER._spawn([boom_large_effect],null,pos,Vector2(0,0),0,0,0)
		obj.scale = Vector2(boom_scale, boom_scale)

func _do_modules() -> void:
	for i in modules.size():
		modules[i]._do_tick()

func _do_tick() -> void:
	position = pos

	if tcpu != null:
		tcpu._do_tick()

	_do_modules()

	if clock < lifespan - 5:
		_boom()

	if boom_scale > 0.5 && clock > 0.2 * lifespan && clock < lifespan:
		_smoke()

	if clock == lifespan:
		dead = true

	if clock < boom_reverse:
		boom_radius = boom_radius + 16 * boom_scale
	else:
		boom_radius = boom_radius - 16 * boom_scale

	GLOBAL.heatbright = GLOBAL.heatbright + 2 * boom_scale
	clock = clock + 1

func _smoke() -> void:
	var pos_shift := Vector2(0,0)
	var r := 0
	var theta := 0
	var sc := 1
	var obj
	
	if boom_scale > 1:
		for i in round(boom_scale * 2):

			theta = randf() * 2 * PI
			r = randf() * boom_radius * 0.75

			pos_shift = Vector2(r * sin(theta),r * cos(theta))
			obj = SPAWNER._spawn([smoke_effect],null,pos + pos_shift,Vector2(0,0),0,0,0)

			sc = (randf() * .7) + 1
			obj.scale = Vector2(sc, sc)
			obj.modulate = Color(0.5, 0, 0.25, 0.3)

func _remove_ref(s) -> void:

	if tcpu != null:
		tcpu._clean_target(s)

	for i in modules.size():
		if "_remove_ref" in modules[i]:
			modules[i]._remove_ref(s)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
