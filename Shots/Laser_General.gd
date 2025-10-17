class_name Laser_General
extends Node2D

@export var base_damage = 1.0
@export var force = 1.0
@export var damage_type = "LASER"
@export var visual_target = false
var clock = 0
var damage = 0.0
@export var lifespan = 5
@export var shot_scale := float(1)
var mat
@onready var beam = $Sprite2D
var beam_wide = 1.0
var beam_long = 1.0
var dead = false
var is_type = "LASER"
var armor = 1
var player
var pos := Vector2(0,0)
var spawn_id = 0
var rotate = 0
var pa
var pb
var pa_pos := Vector2(0,0)
var pb_pos := Vector2(0,0)
var pa_id = 0
var pb_id = 0

func _ready():
	_calc_damage()
	
	#mat = get_material()
	#if(mat != null):
	#	mat.set_shader_parameter("phase",randf() * 2 * PI)

func _ignite(new_pa,new_pb):
	pa_id = new_pa.top.spawn_id
	pb_id = new_pb.spawn_id
	pa = weakref(new_pa)
	pb = weakref(new_pb)
	pa_pos = pa.get_ref().shot_pos
	pb_pos = pb.get_ref().pos
	_draw_laser()

func _draw_laser():
	var r = 0
	var theta = 0
	
	if(pa != null):
		if (!pa.get_ref()):
			pa = null
		else:
			pa_pos = pa.get_ref().shot_pos;
	if(pb != null):
		if (!pb.get_ref()):
			pb = null
		else:
			pb_pos = pb.get_ref().pos;
			if(visual_target == true):
				pb_pos = pb.get_ref().position;
	position = pa_pos
	pos = pa_pos
	r = pos.distance_to(pb_pos)
	theta = atan2(pb_pos.y - pos.y, pb_pos.x - pos.x) + PI / 2
	
	beam_long = r / 128
	beam.scale = Vector2(shot_scale * beam_wide, beam_long)
	rotation = theta
	rotate = theta
	show()

func _process(delta):
	var fade_rate = 10 / lifespan
	modulate = Color(1,1,1,beam_wide)
	beam_wide = beam_wide - fade_rate * delta
	beam_wide = clamp(beam_wide,0,1)
	beam.scale = Vector2(shot_scale * beam_wide,beam_long)
	position = pos

func _calc_damage():
	damage = round(base_damage * 1 * pow(1 + shot_scale,2) + 1)

func _die():
	dead = true

func _do_tick():
	clock = clock + 1
	_calc_damage()
	if(pa_id != -1 && pb_id != -1):
		_draw_laser()
	if(clock >= lifespan):
		armor = 0
	if(armor <= 0):
		_die()

func _do_shader():
	pass

func _set_player(p):
	if(p != null):
		player = p

func _remove_ref(s):
	var i = 0
	if(pa_id == s || pb_id == s):
		hide()
		pa_id = -1
		pb_id = -1
