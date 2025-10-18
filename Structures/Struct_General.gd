class_name Struct_General
extends Thing

@export var build_size:Vector2 = Vector2(1,1)

func _ready() -> void:
	_init_struct()

func _init_struct() -> void:
	armor = max_armor
	inertia = 0
	velocity = Vector2(0.0,0.0)
	max_velocity = 0.0
	max_rotate_velocity = 0.0
	is_type = "STRUCT"
	_do_range()

	if special != "ROCK":
		UNIT_STATE.do_unit_build(self, build_speed)
		UNIT_STATE.do_unit_faction(self)
		UNIT_STATE.do_unit_frames(self)
		UNIT_STATE.do_unit_light_bright(self)

func _build_fix() -> void:
	pos = position
	pos.x = pos.x + 32 * build_size.x / 2
	pos.y = pos.y + 32 * build_size.y / 2
	position = pos
	if hitbox != null:
		hitbox._do_tick()

func _get_ship() -> int:
	var s:int
	var m
	for i in modules.size():
		m = modules[i]
		if m.is_type == "HANGAR" && "ship_id" in m:
			s = m.ship_id[0]
	return s

func _do_tick() -> void:
	velocity = Vector2(0,0)

	super._do_tick()
	_do_damage()

func _do_damage() -> void:
	var burn_pos := Vector2(0,0)
	var burn_rand := 0.0

	'''if armor >= max_armor:
		fire_strength = 0'''

	if armor < max_armor && special == "ARMOR":
		#fire_strength = 1 - armor / max_armor
		UNIT_STATE.do_unit_damage(self)
		if armor < 0:
			hull.frame = 63
		else:
			hull.frame = round(63 - 63 * armor/max_armor)

	if armor < max_armor && special != "ROCK" && special != "ARMOR":
		#fire_strength = 1 - armor / max_armor
		UNIT_STATE.do_unit_damage(self)
		burn_rand = randf() / (build_size.x * build_size.y) * 4

		if burn_rand < 1 - armor / max_armor:

			#burn_pos = pos - 0.8 * 16 * build_size + 0.8 * randf() * build_size * 32
			burn_pos = pos
			burn_pos.x = burn_pos.x - .8 * 16 * build_size.x + .8 * randf() * build_size.x * 32
			burn_pos.y = burn_pos.y - .8 * 16 * build_size.y + .8 * randf() * build_size.y * 32
			
			SPAWNER._spawn([10310], null, burn_pos, Vector2(0,0), 0, 0, 0)
