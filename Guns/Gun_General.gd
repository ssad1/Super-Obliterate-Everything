extends Node2D

var gun_cool:int = 0
@export var fire_sound:int = 0
@export var gun_kick:float = 0
@export var gun_heat:int = 0

var gun_burst:int = 0

@export var gun_burst_max:int = 1
@export var gun_burst_grow:int = 0

var gun_burst_cool:int = 0

@export var gun_burst_heat:int = 0
@export var gun_burst_v_shift:int = 0
@export var gun_burst_even_odd:bool = false
@export var gun_range:int = 500
@export var gun_angle:float = 0.2
@export var gun_v:float = 0
@export var gun_v_noise:float = 0.05
@export var gun_r_noise:float = 0.05
@export var gun_life_noise:float = 0
@export var gun_scale_noise:float = 0
@export var gun_dupes:int = 1
@export var gun_dupe_v_shift:float = 0
@export var gun_arc:float = 0
@export var gun_arc_rounds:int = 1
@export var gun_arc_v:float = 0
@export var gun_sub_arc:float = 0
@export var gun_sub_arc_rounds:int = 1
@export var gun_circle:bool = false
@export var gun_scale:float = 1
@export var velocity_align:bool = true

var offset_pos:Vector2 = Vector2(0,0)
var offset_rotate:float = 0
var offset_radius:float = 0
var ammo
var muzzle
var up
var top
var is_type:String = "GUN"

func _ready() -> void:
	gun_burst = gun_burst_max
	gun_cool = gun_heat
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

func _do_tick() -> void:
	if gun_cool > 0:
		gun_cool = gun_cool - 1
	if gun_burst_cool > 0:
		gun_burst_cool = gun_burst_cool - 1
	if gun_cool == 0:
		_fire_control()

func _fire_control() -> void:
	var tcpu:TargetCPU = up.tcpu
	var firing := false
	var d := 0.0
	var dd := 0.0
	var rb := 0.0
	
	if tcpu != null && up.target_hot == true && tcpu.target_in_range == true:
		rb = atan2(up.pos.y - tcpu.target_pos.y, up.pos.x - tcpu.target_pos.x) - PI / 2
		d = CALC._rotate_direction(up.rotate,rb);
		dd = (up.pos.x - tcpu.target_pos.x) * (up.pos.x - tcpu.target_pos.x) + (up.pos.y - tcpu.target_pos.y) * (up.pos.y - tcpu.target_pos.y);
		if abs(d) < gun_angle && gun_range * gun_range > dd:
			firing = true
	if gun_burst < gun_burst_max:
		firing = true
	if top.guns_safety == true:
		firing = false
	if firing == true && gun_cool == 0 && gun_burst_cool == 0:
		_fire()
		#add in uncloaking
		gun_cool = gun_burst_heat
		gun_burst = gun_burst - 1;
	if gun_burst == 0:
		gun_burst = gun_burst_max;
		gun_burst_cool = 0;
		gun_cool = gun_heat;

func _fire() -> void:
	var shot_pos := Vector2(0,0)
	var shot_velocity := Vector2(0,0)
	var shot_rotate := 0.0
	var mod_gun_v := 0.0
	var mod_gun_arc_rounds := gun_arc_rounds
	var mod_gun_sub_arc_rounds := gun_sub_arc_rounds
	var obj
	var arc_theta := 0.0
	var mod_arc_theta := 0.0
	var mod_gun_arc := gun_arc
	var mod_gun_arc_v := gun_arc_v
	var mod_gun_sub_arc := gun_sub_arc
	var muzzle_offset := Vector2(0,0)
	
	if fire_sound != 0:
		SFX._play_new([fire_sound])
	
	if gun_burst_even_odd == true && gun_burst % 2 == 1:
		mod_gun_arc_rounds = mod_gun_arc_rounds - 1
	if gun_burst_grow != 0:
		mod_gun_arc_rounds = mod_gun_arc_rounds + gun_burst_grow * (gun_burst_max - gun_burst)
	if mod_gun_arc_rounds <= 0:
		mod_gun_arc_rounds = 1
	
	for j in mod_gun_arc_rounds:

		if mod_gun_arc_rounds > 1:
			if gun_circle == false:
				if mod_gun_arc_rounds != gun_arc_rounds:
					mod_gun_arc = gun_arc * mod_gun_arc_rounds / gun_arc_rounds
				arc_theta = 0 - .5 * mod_gun_arc + j * (mod_gun_arc / (mod_gun_arc_rounds - 1))
			else:
				arc_theta = 2 * PI * (float(j) / float(mod_gun_arc_rounds))
			mod_gun_arc_v = gun_arc_v * abs(j - .5 * (mod_gun_arc_rounds - 1))
		else:
			arc_theta = 0
			mod_gun_arc_v = 0


		for k in mod_gun_sub_arc_rounds:


			if mod_gun_sub_arc_rounds > 1:
				if mod_gun_sub_arc_rounds != gun_sub_arc_rounds:
					mod_gun_sub_arc = gun_sub_arc * mod_gun_sub_arc_rounds / gun_sub_arc_rounds
				mod_arc_theta = arc_theta - .5 * mod_gun_sub_arc + k * (mod_gun_sub_arc / (mod_gun_sub_arc_rounds - 1))
			else:
				mod_arc_theta = arc_theta

			
			for i in gun_dupes:

				mod_gun_v = gun_v + i * gun_dupe_v_shift + gun_burst_v_shift * (gun_burst_max - gun_burst) + mod_gun_arc_v

				var off:float = up.rotate + offset_rotate + mod_arc_theta

				shot_pos.x = up.pos.x + offset_radius * sin(off)
				shot_pos.y = up.pos.y - offset_radius * cos(off)

				var rotation:float = up.rotate + mod_arc_theta + PI * (randf() - .5) * gun_r_noise
				var velocity:float = mod_gun_v + mod_gun_v * (randf() - .5) * gun_v_noise

				shot_velocity.x = top.velocity.x + velocity * sin(rotation)
				shot_velocity.y = top.velocity.y - velocity * cos(rotation)


				if velocity_align == true:
					shot_rotate = atan2(shot_velocity.y,shot_velocity.x) + PI / 2
				else:
					shot_rotate = up.rotate
				
				obj = SPAWNER._spawn_dupe(ammo,top.player.id,shot_pos,shot_velocity,shot_rotate,0,0)

				if "shot_scale" in obj:
					obj.shot_scale = gun_scale * (1.0 - gun_scale_noise * randf())
					obj.scale = obj.shot_scale * Vector2(1,1)

				
				if "lifespan" in obj && obj.is_type != "MISSILE":
					if mod_gun_v != 0:
						obj.lifespan = ceil(gun_range / mod_gun_v)
						obj.lifespan = obj.lifespan * (1.0 - gun_life_noise * randf())
					else:
						obj.lifespan = 20
				

				if ("tcpu" in up && "tcpu" in obj) && (up.tcpu != null && obj.tcpu != null):
					obj.tcpu.targets = up.tcpu.targets
				

				obj.show()

				if top.has_method("_apply_force"):
					top._apply_force(gun_kick,-1 * shot_velocity.normalized())

				
	if muzzle != null:
		muzzle_offset.x = 0 + offset_radius * sin(up.rotate + offset_rotate) - offset_pos.x
		muzzle_offset.y = 0 - offset_radius * cos(up.rotate + offset_rotate) - offset_pos.y
		muzzle._shoot(muzzle_offset,up.rotate)
