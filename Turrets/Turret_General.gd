extends Node2D

@onready var tcpu_node = preload("res://Modules/TargetCPU.tscn")
@onready var FOV_node = preload("res://Modules/Target_FOV.tscn")
@onready var hull:Sprite2D = $Hull

var offset_pos:Vector2 = Vector2(0,0)
var offset_radius:float = 0
var offset_rotate:float = 0
var pos:Vector2 = Vector2(0,0)
var rotate:float = 0
var rotate_velocity:float = 0
var last_rotate:float = 0
@export var max_rotate_velocity:float = 0.1
@export var target_profile:String = "NORMAL"
@export var tier:float = 1
var up
var player
var tcpu:TargetCPU
var tFOV:Area2D
var ai_mode:int = 1
var spawn_id:int = 0
var modules = []
var is_type:String = "TURRET"
var range_radius:int = 0
var target_hot:bool = false

@export var build_speed:float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	up = get_parent()
	offset_pos = position
	offset_radius = sqrt(pow(offset_pos.x,2) + pow(offset_pos.y,2))
	offset_rotate = atan2(offset_pos.y, offset_pos.x) - PI/2
	up.modules.append(self)
	tcpu = tcpu_node.instantiate()

	tFOV = FOV_node.instantiate()
	add_child(tFOV)

	tcpu.up = self
	tcpu.set_target_profile = target_profile
	_do_range()
	UNIT_STATE.do_unit_build(self, build_speed)
	UNIT_STATE.do_unit_faction(self)
	UNIT_STATE.do_unit_frames(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_do_anim()
	pass

func _do_ai():
	var target_rotate := 0.0
	var rotate_d := 0.0
	target_hot = false
	match ai_mode:
		1:
			if tcpu._target_closest(pos) != -1:
				target_hot = true
				target_rotate = atan2(pos.y - tcpu.target_pos.y,pos.x - tcpu.target_pos.x) - PI/2
			else:
				target_rotate = last_rotate
			rotate_d = CALC._rotate_direction(rotate,target_rotate)
			if abs(rotate_d) < max_rotate_velocity:
				rotate_d = 0
				rotate = target_rotate
			if rotate_d < -0.01:
				_do_command("LEFT")
			if rotate_d > 0.01:
				_do_command("RIGHT")
			last_rotate = rotate	

func _do_anim():
	var f:int
	f = floor(rotate * hull.hframes * hull.vframes / (2 * PI))
	hull.frame = f

func _do_command(c):
	match c:
		"LEFT":
			rotate = rotate - max_rotate_velocity
		"RIGHT":
			rotate = rotate + max_rotate_velocity

func _do_modules():
	for module in modules:
		module._do_tick()

func _do_physics():
	if abs(rotate_velocity) > max_rotate_velocity:
		rotate_velocity = rotate_velocity * .95
	rotate = rotate + rotate_velocity
	if rotate >= TAU:
		rotate = rotate - TAU
	if rotate < 0:
		rotate = rotate + TAU

func _do_range():
	range_radius = 0
	for module in modules:
		if "gun_range" in module && module.gun_range > range_radius:
			range_radius = module.gun_range
		if "range_radius" in module && module.range_radius > range_radius:
			range_radius = module.range_radius
	
	tFOV._initialize_FOV_area(range_radius)
	tFOV._bind_tcpu(tcpu)

func _do_shader():
	var mat := hull.get_material()
	
	#Fix this some day if needed
	
	if player != null:
		mat.set_shader_parameter("flag_color",player.flag_color)
		mat.set_shader_parameter("light_color",player.light_color)
	mat.set_shader_parameter("light_bright",up.light_bright)

	#mat.set_shader_parameter("burn_color",up.burn_color)
	#mat.set_shader_parameter("burn_bright",up.burn_bright)
	#mat.set_shader_parameter("cloak_strength",up.cloak_strength)
	#mat.set_shader_parameter("freeze_strength",up.freeze_strength)
	#mat.set_shader_parameter("acid_strength",up.acid_strength)
	#mat.set_shader_parameter("damage_strength",up.damage_strength)
	#mat.set_shader_parameter("burnt_strength",up.burnt_strength)
	#mat.set_shader_parameter("dissolve_strength",up.dissolve_strength)
	#mat.set_shader_parameter("fire_strength",up.fire_strength)
	#mat.set_shader_parameter("shock_strength",up.shock_strength)
	#mat.set_shader_parameter("shield_strength",up.shield_strength)
	#mat.set_shader_parameter("shield_damage",up.shield_damage)
	#mat.set_shader_parameter("build_strength",up.build_strength)
	#mat.set_shader_parameter("swirl_strength",up.swirl_strength)

func _do_tick():
	spawn_id = up.spawn_id
	player = up.player
	pos = up.pos + offset_pos
	if tcpu != null:
		tcpu._do_tick()
	_do_ai()
	_do_physics()
	_do_modules()

func _remove_ref(s):
	if tcpu != null:
		tcpu._clean_target(s)
