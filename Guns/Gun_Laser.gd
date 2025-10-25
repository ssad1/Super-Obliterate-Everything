extends Node2D

var gun_cool = 0
@export var fire_sound:SFX.sound = 0
@export var gun_kick:float = 0
@export var gun_heat:int = 0
@export var gun_range:int = 500
@export var gun_angle:float = 0.1
@export var gun_scale:float = 1
@export var mining_laser:bool = false

var shot_pos:Vector2 = Vector2(0,0)
var offset_pos:Vector2 = Vector2(0,0)
var offset_rotate:float = 0
var offset_radius:float = 0
var ammo
var muzzle
var up
var top
var is_type = "GUN"

func _ready() -> void:
	gun_cool = gun_heat/2 #make laser units have faster reaction speed only when detecting something
	ammo = get_child(0)
	up = get_parent()
	offset_pos = position
	offset_radius = sqrt(pow(offset_pos.x,2) + pow(offset_pos.y,2))
	offset_rotate = atan2(offset_pos.y,offset_pos.x) + PI / 2
	up.modules.append(self)
	
	if up.is_type == "TURRET" or up.is_type == "TRIGGER":
		top = up.get_parent()
	else:
		top = up

func _process(delta:float) -> void:

	var rotation:float = up.rotate + offset_rotate

	if up.is_type != "TURRET":
		shot_pos.x = up.position.x + offset_radius * sin(rotation)
		shot_pos.y = up.position.y - offset_radius * cos(rotation)
	else:
		shot_pos.x = up.position.x + up.up.position.x + offset_radius * sin(rotation)
		shot_pos.y = up.position.y + up.up.position.y - offset_radius * cos(rotation)

func _do_tick() -> void:
	#shot_pos.x = up.pos.x + offset_radius * sin(up.rotate + offset_rotate)
	#shot_pos.y = up.pos.y - offset_radius * cos(up.rotate + offset_rotate)
	if gun_cool > 0:
		gun_cool = gun_cool - 1
	if gun_cool == 0:
		_fire_control()

func _fire_control() -> void:

	var tcpu:TargetCPU = up.tcpu
	var firing := false
	var d := 0.0
	var rb := 0.0
	var a := 0
	var b := 0

	if tcpu != null && tcpu.target_i != -1:

		rb = atan2(up.pos.y - tcpu.target_pos.y, up.pos.x - tcpu.target_pos.x) - PI / 2
		d = CALC._rotate_direction(up.rotate, rb);

		if abs(d) < gun_angle:
			firing = true

	if top.guns_safety || tcpu.targets.size() == 0 || !tcpu.target_in_range:
		firing = false

	if firing:
		a = tcpu.target_i
		b = tcpu._target_closest(up.pos)

		if b == -1: return

		if up.pos.distance_to(tcpu.targets[b].pos) > up.range_radius:
			firing = false

		if a != b :
			firing = false
		if tcpu.targets.size() == 0:
			firing == false
		if(
		tcpu.targets[tcpu.target_i].is_type != "SHIP" && 
		tcpu.targets[tcpu.target_i].is_type != "STRUCT" && 
		tcpu.targets[tcpu.target_i].is_type != "SHOT" && 
		tcpu.targets[tcpu.target_i].is_type != "MISSILE"):
			firing = false

	if firing && gun_cool == 0 && tcpu.target_in_range:
		_fire()
		#add in uncloaking
		gun_cool = gun_heat

func _fire() -> void:
	var obj
	var muzzle_offset := Vector2(0,0)
	var tcpu:TargetCPU = up.tcpu

	if fire_sound != 0:
		SFX._play_new([fire_sound])

	if(
	"tcpu" in up && 
	up.tcpu != null && 
	up.tcpu.target_i != -1 && 
	up.tcpu.target_i < up.tcpu.targets.size()):

		obj = SPAWNER._spawn_laser(ammo, top.player.id, self, up.tcpu.targets[up.tcpu.target_i])

		if "shot_scale" in obj:
			obj.shot_scale = gun_scale

		obj.show()
		obj._calc_damage()
		up.tcpu.targets[up.tcpu.target_i]._hit(obj)

		if mining_laser:
			top._mine_rock()

	if top.has_method("_apply_force"):

		top._apply_force(gun_kick, Vector2(shot_pos.x - tcpu.target_pos.x, shot_pos.y - tcpu.target_pos.y).normalized())

	if muzzle != null:

		var rotation:float = up.rotate + offset_rotate

		muzzle_offset.x = offset_radius * sin(rotation) - offset_pos.x
		muzzle_offset.y = -offset_radius * cos(rotation) - offset_pos.y
		muzzle._shoot(muzzle_offset,up.rotate)
