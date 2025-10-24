class_name Ship_General
extends Thing

@export var thrust:float = 0
@export var aihigh:String = "STANDARD"
@export var aistandoff:int = 100
@export var factory:SPAWNER.spawn_objs

var aiclock:int = 0
var aiflag:String = ""
var aimid:String = ""
var ailow:String = ""
var target_hot:bool = false
var target_pos:Vector2 = Vector2(0,0)
var target_velocity:Vector2 = Vector2(0,0)
var base = null
var engine_burn:float = 0
var miner_rock:bool = false
var build_mission

func _ready() -> void:
	_init_ship()

func _add_payload(e,m,s) -> void:
	for module in modules:
		if module.name == "Module_Delivery":
			module.deliver_energy = e
			module.deliver_metal = m
			module.deliver_supply = s

func _init_ship() -> void:
	armor = max_armor
	is_type = "SHIP"
	_do_range()
	UNIT_STATE.do_unit_build(self, build_speed)
	UNIT_STATE.do_unit_faction(self)
	UNIT_STATE.do_unit_frames(self)
	UNIT_STATE.do_unit_burn(self)
	UNIT_STATE.do_unit_light_bright(self)

func _init_builder() -> void:
	if build_mission == null: return

	target_pos = Vector2(32 * build_mission[3],32 * build_mission[4])

	var obj = player.item_bag_objs[build_mission[2]]

	if "build_size" in obj:
		target_pos = target_pos + 16 * player.item_bag_objs[build_mission[2]].build_size
	if "factory" in obj:
		target_pos = target_pos + 16 * player.item_bag_factory_objs[build_mission[2]].build_size

	rotate = atan2(pos.y - target_pos.y,pos.x - target_pos.x) - PI/2

func _init_center() -> void:
	target_pos = 0.5 * SPAWNER.game.mapsize
	rotate = atan2(pos.y - target_pos.y,pos.x - target_pos.x) - PI/2

func _ship_fix() -> void:
	if rotate >= TAU:
		rotate = rotate - TAU
	if rotate < 0:
		rotate = rotate + TAU
	rotation = 0

func _free_base() -> void:
	base = null

func _die() -> void:
	if base != null:
		base._remove_ship(spawn_id)
	super._die()

func _do_tick() -> void:
	super._do_tick()
	_do_damage()
	_do_ai()
	
func _process(delta:float) -> void:
	var blend_pos := position + (pos - position) * 0.1 + 0.2 * velocity
	set_position(blend_pos)
	_do_anim(delta)
	_do_selection(delta)

func _do_anim(delta:float) -> void:

	if hull == null: return

	var f:int
	_ship_fix()

	if aihigh != "HALO":
		f = floor(rotate * hull.hframes * hull.vframes / (2 * PI))
		hull.frame = f

	if engine_burn > 0:
		engine_burn = engine_burn - delta
		engine_burn = clamp(engine_burn,0.0,1.0)

	if has_node("Burn"):

		var burn:Sprite2D = $Burn

		burn.frame = f
		burn.modulate = Color(1,0,0,engine_burn)
		if engine_burn == 0:
			burn.hide()
		else:
			burn.show()

func _do_build() -> void:

	var success:bool = player._build_struct(build_mission,false)

	if success:
		build_mission = null
		vanish = true
		armor = -100
		if stats != null:
			print("Kill Stats")
			stats.hide()
			stats.queue_free()
			stats = null
	else:
		aiflag = "RETURN"

func _do_command(c:String) -> void:
	match c:
		"LEFT":
			rotate = rotate - max_rotate_velocity
		"RIGHT":
			rotate = rotate + max_rotate_velocity
		"THRUST":
			velocity.x = velocity.x + thrust * sin(rotate)
			velocity.y = velocity.y - thrust * cos(rotate)
			engine_burn = engine_burn + .2
			engine_burn = clamp(engine_burn,0.0,1.0)

func _do_damage() -> void:

	UNIT_STATE.do_unit_damage(self)

func _do_ai() -> void:
	if tcpu != null:
		_ai_high()
		_ai_mid()
		_ai_low()

func _ai_high() -> void:
	if armor <= 0:
		aihigh = ""
		aimid = ""
		ailow = ""
	target_hot = false
	match aihigh:
		"STANDARD":
			aimid = "COMBAT"
		"HALO":
			rotate = 0
			aimid = "HALO COMBAT"
		"MINER":
			if !miner_rock:
				tcpu.set_target_profile = "MINER_MINE"
				aimid = "COMBAT"
				guns_safety = false
				tcpu.found_victim = false
				if player != null:
					if player.ai_no_rocks:
						tcpu.set_target_profile = "MINER_RETURN"
						aimid = "INTERCEPT"
						guns_safety = true
						tcpu.found_victim = false
			if miner_rock:
				tcpu.set_target_profile = "MINER_RETURN"
				aimid = "INTERCEPT"
				guns_safety = true
				_mine_drop()
		"METALPORTER":
			tcpu.set_target_profile = "STATION"
			aimid = "INTERCEPT"
		"BUILDER":
			if aiflag == "":
				aimid = "BUILDER"
			if aiflag == "RETURN":
				build_mission = null
				tcpu.set_target_profile = "STATION"
				aimid = "INTERCEPT"
		"KAMIKAZE":
			aimid = "KAMIKAZE"

func _ai_mid() -> void:
	var d := 0.0
	var check_return := false
	var center:Vector2 = SPAWNER.game.mapsize / 2

	match aimid:
		"COMBAT":

			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
				d = pos.distance_to(target_pos)
				if d < aistandoff:
					ailow = "POINT"
				else:
					ailow = "CHASE"
			else:
				target_hot = false
				target_velocity = Vector2(0,0)
				d = pos.distance_to(target_pos)
				if d < aistandoff:
					ailow = "POINT"
					target_pos = SPAWNER.game.mapsize * CALC._rand()
					ailow = "CHASE"

			check_return = true
		"KAMIKAZE":

			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
			else:
				target_pos = center
				target_velocity = Vector2(0,0)

			d = pos.distance_to(target_pos)

			if d < aistandoff:
				armor = -100
			else:
				ailow = "CHASE"

			check_return = true
		"HALO COMBAT":

			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
			else:
				target_pos = center
				target_velocity = Vector2(0,0)

			d = pos.distance_to(target_pos)

			if d < aistandoff:
				ailow = "FLOAT"
			else:
				ailow = "HALO CHASE"

			check_return = false
			if pos.x < -100 || pos.x > SPAWNER.game.mapsize.x + 100 || pos.y < -100 || pos.x > SPAWNER.game.mapsize.y + 100:

				target_pos = center
				target_velocity = Vector2(0,0)
				ailow = "HALO CHASE"
		"INTERCEPT":
			#TODO: Implement Lead Collision
			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
			else:
				target_pos = center
				target_velocity = Vector2(0,0)
			ailow = "STATIC COLLISION"
		"BUILDER":
			if build_mission != null:

				var build2 = build_mission[2]

				target_pos = Vector2(32 * build_mission[3], 32 * build_mission[4])
				
				if "build_size" in player.item_bag_objs[build2]:
					target_pos = target_pos + 16 * player.item_bag_objs[build2].build_size
				if "factory" in player.item_bag_objs[build2]:
					target_pos = target_pos + 16 * player.item_bag_factory_objs[build2].build_size

				target_velocity = Vector2(0,0)
				ailow = "STATIC COLLISION"

			if pos.distance_to(target_pos) < 12:
				_do_build()

			check_return = true

	if (
		check_return && pos.x < -100 || 
		pos.x > SPAWNER.game.mapsize.x + 100 || 
		pos.y < -100 || 
		pos.x > SPAWNER.game.mapsize.y + 100
	   ):
			target_pos = center
			target_velocity = Vector2(0,0)
			ailow = "CHASE"

func _ai_low() -> void:
	var r := 0.0
	var theta := 0.0
	var target_rotate := 0.0
	var p1 := Vector2(0,0)
	var p2 := Vector2(0,0)
	var p3 := Vector2(0,0)

	var thrust_dir := abs(CALC._rotate_direction(rotate,theta))
	var thrust_vel := sqrt(pow(velocity.x,2) + pow(velocity.y,2))

	match ailow:
		"FLOAT":
			pass
		"POINT":
			_ai_basic("POINT")
		"CHASE":
			r = _ai_basic("POINT")
			if abs(r) < 0.05:
				theta = atan2(velocity.y,velocity.x) - PI/2 + PI
				if thrust_dir > 0.2 || thrust_vel < max_velocity * 0.9:
					_do_command("THRUST")
		"CHARGE":
			_ai_basic("POINT")
			_do_command("THRUST")
		"HALO CHASE":
			target_rotate = atan2(pos.y - target_pos.y,pos.x - target_pos.x) - PI/2
			velocity.x = velocity.x + thrust * sin(target_rotate)
			velocity.y = velocity.y - thrust * cos(target_rotate)
		"STATIC COLLISION":
			p1 = target_pos - 3 * velocity
			target_pos = p1
			r = _ai_basic("POINT")
			if abs(r) < 0.05:
				theta = atan2(velocity.y,velocity.x) - PI/2 + PI
				if thrust_dir > 0.2 || thrust_vel < max_velocity * 0.9:
					_do_command("THRUST")
			
func _ai_basic(s:String) -> float:

	var rotate_d := 0.0
	var target_rotate := 0.0
	var r := 0.0

	match s:
		"POINT":
			target_rotate = atan2(pos.y - target_pos.y,pos.x - target_pos.x) - PI/2
			rotate_d = CALC._rotate_direction(rotate,target_rotate)
			if abs(rotate_d) < max_rotate_velocity:
				rotate_d = 0
				rotate = target_rotate
			if rotate_d < -0.01:
				_do_command("LEFT")
			if rotate_d > 0.01:
				_do_command("RIGHT")
			r = rotate_d
			
	return r

func _mine_rock() -> void:
	miner_rock = true
	for module in modules:
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
		pos.x > target.pos.x - 24 && 
		pos.x < target.pos.x + 24 && 
		pos.y > target.pos.y - 24 && 
		pos.y < target.pos.y + 24):
			miner_rock = false
			tp = target.position
			dropped = true
			target._add_rock()
			for module in modules:
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
