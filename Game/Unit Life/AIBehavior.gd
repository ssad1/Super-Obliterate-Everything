class_name AI_Behavior

enum ai_flag {
	NONE,
	RETURN
}

enum ai_high {
	NONE,
	STANDART,
	HALO,
	BUILDER,
	MINER,
	METALPORTER,
	KAMIZAZE,
	B1,
	M1,
	R1
}
enum ai_mid {
	NONE,
	COMBAT,
	HALO_COMBAT,
	INTERCEPT,
	MISSILE_INTERCEPT,
	KAMIKAZE,
	ROCKET,
	BOMB,
	BUILDER
}
enum ai_low {
	NONE,
	POINT,
	CHASE,
	FLOAT,
	HALO_CHASE,
	STATIC_COLLISION,
	CHARGE
}
enum commands {
	NONE,
	THRUST,
	LEFT,
	RIGHT
}

var high_behavior:Dictionary[ai_high, Callable] = {
	ai_high.NONE: func() -> void: pass,
	ai_high.STANDART: _high_standart,
	ai_high.HALO: _high_halo,
	ai_high.BUILDER: _high_builder,
	ai_high.MINER: _high_miner,
	ai_high.METALPORTER: _high_metalporter,
	ai_high.KAMIZAZE: _high_kamikaze,
	ai_high.B1: _high_B1,
	ai_high.M1: _high_M1,
	ai_high.R1: _high_R1,
}

var mid_behavior:Dictionary[ai_mid, Callable] = {
	ai_mid.NONE: func() -> void: pass,
	ai_mid.COMBAT: _mid_combat,
	ai_mid.HALO_COMBAT: _mid_halo_combat,
	ai_mid.INTERCEPT: _mid_intercept,
	ai_mid.MISSILE_INTERCEPT: _mid_missile_intercept,
	ai_mid.KAMIKAZE: _mid_kamikaze,
	ai_mid.BUILDER: _mid_builder,
	ai_mid.ROCKET: _mid_rocket,
	ai_mid.BOMB: _mid_bomb,
}

var low_behavior:Dictionary[ai_low, Callable] = {
	ai_low.NONE: func() -> void: pass,
	ai_low.POINT: _low_point,
	ai_low.CHASE: _low_chase,
	ai_low.FLOAT: _low_float,
	ai_low.HALO_CHASE: _low_halo_chase,
	ai_low.STATIC_COLLISION: _low_static_collision,
	ai_low.CHARGE: _low_charge
}

var unit:Thing
var tcpu:TargetCPU
var target_velocity:Vector2 = Vector2(0,0)
var miner_rock:bool = false
var vel_off:float = 0.0
var PIsum:float = CALC.half_PI + PI
var aiflag:ai_flag = ai_flag.NONE

#make those point at the exact function they need to be

var aihigh:ai_high = ai_high.NONE:
	set(value):
		unit._ai_high = high_behavior[value]

var aimid:ai_mid = ai_mid.NONE:
	set(value):
		unit._ai_mid = mid_behavior[value]

var ailow:ai_low = ai_low.NONE:
	set(value):
		unit._ai_low = low_behavior[value]

####----class methods----####

func _init(currentUnit) -> void:
	unit = currentUnit
	unit._ai_high = high_behavior[unit.aihigh]
	unit._ai_mid = mid_behavior[ai_mid.NONE]
	unit._ai_low = mid_behavior[ai_low.NONE]
	vel_off = currentUnit.max_velocity * 0.9
	tcpu = unit.tcpu

func _do_build() -> void:

	var success:bool = unit.player._build_struct(unit.build_mission,false)

	if success:
		unit.build_mission = null
		unit.vanish = true
		unit.armor = -100
	else:
		aiflag = ai_flag.RETURN

func _do_command(c:int) -> void:
	match c:
		commands.LEFT:
			unit.rotate = unit.rotate - unit.max_rotate_velocity
		commands.RIGHT:
			unit.rotate = unit.rotate + unit.max_rotate_velocity
		commands.THRUST:
			unit.velocity.x = unit.velocity.x + unit.thrust * sin(unit.rotate)
			unit.velocity.y = unit.velocity.y - unit.thrust * cos(unit.rotate)
			unit.engine_burn = unit.engine_burn + .2
			unit.engine_burn = clamp(unit.engine_burn,0.0,1.0)
	unit._do_anim()
	
#Different behaviors encapsulated as functions

####----AI highs----####

func _high_standart() -> void:
	aimid = ai_mid.COMBAT

func _high_halo() -> void:
	unit.rotate = 0
	aimid = ai_mid.HALO_COMBAT

func _high_miner() -> void:
	if !miner_rock:
		tcpu.set_target_profile = tcpu.profile.MINER_MINE
		aimid = ai_mid.COMBAT
		unit.guns_safety = false
		tcpu.found_victim = false
		if unit.player != null:
			if unit.player.ai_no_rocks:
				tcpu.set_target_profile = tcpu.profile.MINER_RETURN
				aimid = ai_mid.INTERCEPT
				unit.guns_safety = true
				tcpu.found_victim = false
	if miner_rock:
		tcpu.set_target_profile = tcpu.profile.MINER_RETURN
		aimid = ai_mid.INTERCEPT
		unit.guns_safety = true
		_mine_drop()

func _high_metalporter() -> void:
	tcpu.set_target_profile = tcpu.profile.STATION
	aimid = ai_mid.INTERCEPT

func _high_builder() -> void:
	if aiflag == ai_flag.NONE:
		aimid = ai_mid.BUILDER
	if aiflag == ai_flag.RETURN:
		unit.build_mission = null
		tcpu.set_target_profile = tcpu.profile.STATION
		aimid = ai_mid.INTERCEPT

func _high_kamikaze() -> void:
	aimid = ai_mid.KAMIKAZE

func _high_R1() -> void:
	aimid = ai_mid.ROCKET
	ailow = ai_low.NONE

func _high_B1() -> void:
	aimid = ai_mid.BOMB
	ailow = ai_low.NONE

func _high_M1() -> void:
	aimid = ai_mid.NONE
	ailow = ai_low.NONE
	if unit.missile_clock > 5 && unit.missile_clock < unit.lifespan - 5:
		aimid = ai_mid.MISSILE_INTERCEPT

####----AI mids----####

var d := 0.0
var check_return := false
var center:Vector2 = SPAWNER.game.mapsize / 2

func _mid_combat() -> void:
	if tcpu._target_closest(unit.pos) != -1:
		target_velocity = tcpu.target_velocity
		unit.target_hot = true
		d = unit.pos.distance_to(tcpu.target_pos)
		if d < unit.aistandoff:
			ailow = ai_low.POINT
		else:
			ailow = ai_low.CHASE
	else:
		unit.target_hot = false
		target_velocity = Vector2(0,0)
		d = unit.pos.distance_to(tcpu.target_pos)
		if d < unit.aistandoff:
			ailow = ai_low.POINT
			tcpu.target_pos = SPAWNER.game.mapsize * CALC._rand()
			ailow = ai_low.CHASE

	check_return = true

func _mid_kamikaze() -> void:
	if tcpu._target_closest(unit.pos) != -1:
		 
		target_velocity = tcpu.target_velocity
		unit.target_hot = true
	else:
		tcpu.target_pos = center
		target_velocity = Vector2(0,0)

	d = unit.pos.distance_to(tcpu.target_pos)

	if d < unit.aistandoff:
		unit.armor = -100
	else:
		ailow = ai_low.CHASE

	check_return = true

func _mid_halo_combat() -> void:
	if tcpu._target_closest(unit.pos) != -1:
		 
		target_velocity = tcpu.target_velocity
		unit.target_hot = true
	else:
		tcpu.target_pos = center
		target_velocity = Vector2(0,0)

	d = unit.pos.distance_to(tcpu.target_pos)

	if d < unit.aistandoff:
		ailow = ai_low.FLOAT
	else:
		ailow = ai_low.HALO_CHASE

	check_return = false
	if unit.pos.x < -100 || unit.pos.x > SPAWNER.game.mapsize.x + 100 || unit.pos.y < -100 || unit.pos.x > SPAWNER.game.mapsize.y + 100:

		tcpu.target_pos = center
		target_velocity = Vector2(0,0)
		ailow = ai_low.HALO_CHASE

#TODO: Implement Lead Collision
func _mid_intercept() -> void:
	if tcpu._target_closest(unit.pos) != -1:
		 
		target_velocity = tcpu.target_velocity
		unit.target_hot = true
	else:
		tcpu.target_pos = center
		target_velocity = Vector2(0,0)
	ailow = ai_low.STATIC_COLLISION

func _mid_builder() -> void:
	if unit.build_mission != null:

		var build2 = unit.build_mission[2]

		tcpu.target_pos = Vector2(32 * unit.build_mission[3], 32 * unit.build_mission[4])
		
		if "build_size" in unit.player.item_bag_objs[build2]:
			tcpu.target_pos = tcpu.target_pos + 16 * unit.player.item_bag_objs[build2].build_size
		if "factory" in unit.player.item_bag_objs[build2]:
			tcpu.target_pos = tcpu.target_pos + 16 * unit.player.item_bag_factory_objs[build2].build_size

		target_velocity = Vector2(0,0)
		ailow = ai_low.STATIC_COLLISION

	if unit.pos.distance_to(tcpu.target_pos) < 12:
		_do_build()

	check_return = true

func _mid_rocket() -> void:
	if tcpu._target_closest(unit.pos) != -1:
		 
		target_velocity = tcpu.target_velocity
		unit.target_hot = true
		d = unit.pos.distance_to(tcpu.target_pos)

		if d < unit.detonate_range:
			unit.armor = -100

	if unit.missile_clock > 5:
		_do_command(commands.THRUST)
		unit._do_smoke()

	ailow = ai_low.NONE

func _mid_bomb() -> void:
	if tcpu._target_closest(unit.pos) != -1:
		 
		target_velocity = tcpu.target_velocity
		unit.target_hot = true
		d = unit.pos.distance_to(tcpu.target_pos)

		if d < unit.detonate_range:
			unit.armor = -100

	if unit.missile_clock > 3 && unit.missile_clock < 10:
		_do_command(commands.THRUST)
		unit._do_smoke()

	ailow = ai_low.NONE

#TODO: Implement Lead Collision
func _mid_missile_intercept() -> void:
	if tcpu._target_closest(unit.pos) != -1:
		 
		target_velocity = tcpu.target_velocity
		unit.target_hot = true
		d = unit.pos.distance_to(tcpu.target_pos)

		if d < unit.detonate_range:
			unit.armor = -100

		ailow = ai_low.CHARGE
		unit._do_smoke()

	else:
		ailow = ai_low.NONE

####----AI lows----####

var facing_rotate := 0.0
var target_rotate := 0.0
var pos1 := Vector2(0,0)
var theta := 0.0
var thrust_dir:float = 0.0
var thrust_vel:float = 0.0

func _low_float() -> void:
	pass

func _low_point() -> void:
	_ai_basic()

func _low_chase() -> void:
	facing_rotate = _ai_basic()
	if abs(facing_rotate) < 0.05:
		theta = atan2(unit.velocity.y, unit.velocity.x) - PIsum
		if thrust_dir > 0.2 || thrust_vel < vel_off:
			_do_command(commands.THRUST)

func _low_charge() -> void:
	_ai_basic()
	_do_command(commands.THRUST)

func _low_halo_chase() -> void:
	target_rotate = atan2(unit.pos.y - tcpu.target_pos.y, unit.pos.x - tcpu.target_pos.x) - CALC.half_PI
	unit.velocity.x = unit.velocity.x + unit.thrust * sin(target_rotate)
	unit.velocity.y = unit.velocity.y - unit.thrust * cos(target_rotate)

func _low_static_collision() -> void:
	pos1 = tcpu.target_pos - 3 * unit.velocity
	tcpu.target_pos = pos1
	facing_rotate = _ai_basic()
	if abs(facing_rotate) < 0.05:
		theta = atan2(unit.velocity.y, unit.velocity.x) - PIsum
		if thrust_dir > 0.2 || thrust_vel < vel_off:
			_do_command(commands.THRUST)

func _ai_basic() -> float:

	var rotate_d := 0.0
	var target_rotate := 0.0
	var r := 0.0
	
	target_rotate = atan2(unit.pos.y - tcpu.target_pos.y, unit.pos.x - tcpu.target_pos.x) - CALC.half_PI
	rotate_d = CALC._rotate_direction(unit.rotate,target_rotate)
	if abs(rotate_d) < unit.max_rotate_velocity:
		rotate_d = 0
		unit.rotate = target_rotate
	if rotate_d < -0.01:
		_do_command(commands.LEFT)
	if rotate_d > 0.01:
		_do_command(commands.RIGHT)
	r = rotate_d
			
	return r

####----miner related AI----####

func mine_rock() -> void:
	miner_rock = true
	for module in unit.modules:
		if module.name == "Module_Rock":
			module._fire()

func _mine_drop() -> void:
	var tp := Vector2(0,0)
	var dropped := false
	var obj

	#make it search the entire map for a valid extractor

	tcpu.found_victim = false
	tcpu._do_scan()

	for target in tcpu.targets:
		if(
		target.special == "EXTRACTOR" &&
		unit.pos.x > target.pos.x - 24 && 
		unit.pos.x < target.pos.x + 24 && 
		unit.pos.y > target.pos.y - 24 && 
		unit.pos.y < target.pos.y + 24):
			miner_rock = false
			tp = target.position
			dropped = true
			target._add_rock()
			for module in unit.modules:
				if module.name == "Module_Rock":
					module.hide()
				if "gun_cool" in module:
					module.gun_cool = module.gun_heat
	if dropped:
		tcpu.targets = []
		SPAWNER._spawn([SPAWNER.spawn_objs.EFFECT_ASTEROID_BOOM_SMALL], null, tp, Vector2(0,0), 0, 0, 0)
		SPAWNER._spawn([SPAWNER.spawn_objs.EFFECT_MINER_FLASH], null, tp, Vector2(0,0), 0, 0, 0)
		obj = SPAWNER._spawn([SPAWNER.spawn_objs.EFFECT_SPARKS_MEDIUM], null, tp, Vector2(0,0), 0, 0, 0)
		obj.scale = Vector2(.65,.65)

####----builder related----####

func init_builder() -> void:
	if unit.build_mission == null: return

	tcpu.target_pos = Vector2(32 * unit.build_mission[3],32 * unit.build_mission[4])

	var obj = unit.player.item_bag_objs[unit.build_mission[2]]
	
	if "build_size" in obj:
		tcpu.target_pos = tcpu.target_pos + 16 * unit.player.item_bag_objs[unit.build_mission[2]].build_size
	if "factory" in obj:
		tcpu.target_pos = tcpu.target_pos + 16 * unit.player.item_bag_factory_objs[unit.build_mission[2]].build_size

	unit.rotate = atan2(unit.pos.y - tcpu.target_pos.y, unit.pos.x - tcpu.target_pos.x) - CALC.half_PI
