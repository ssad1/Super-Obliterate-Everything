class_name Ship_Missile
extends Ship_General

@export var lifespan:int = 20
@export var detonate_range:int = 16
var missile_clock:int = 0
@export var shot_scale:float = 1
@export var damage:float = 1
@export var force:float = 1
@export var smoke_trail:SPAWNER.spawn_objs = 0

func _ready() -> void:
	_init_missile()

func _process(delta:float) -> void:
	var blend_pos := position + (pos - position) * 0.1 + 0.2 * velocity
	set_position(blend_pos)
	_do_anim(delta)
	_do_selection(delta)

	if inactive: return

	tick_clock += delta # * tick_speed
	if tick_clock > 0.1:
		tick_clock -= 0.1
		_do_tick()
	if tick_clock > 0.2:
		tick_clock = 0.2
	
	physics_clock += delta
	if physics_clock > 0.1:
		physics_clock -= 0.1

		_do_physics()

	if physics_clock > 0.2:
		physics_clock = 0.2

func _init_missile() -> void:
	scale = shot_scale * Vector2(1,1)
	armor = max_armor
	is_type = UNIT_STATE.type.MISSILE
	_do_range()
	has_tcpu = tcpu != null

func _do_tick() -> void:
	missile_clock = missile_clock + 1
	if missile_clock >= lifespan:
		armor = -100
	
	super._do_tick()

func _do_smoke() -> void:
	var offset := Vector2(0,0)
	var obj
	if smoke_trail != 0:
		offset.x = -16 * sin(rotate)
		offset.y = 16 * cos(rotate)
		obj = SPAWNER._spawn([smoke_trail], null, position + offset, Vector2(0,0),0,0,0)
		obj.scale = Vector2(0.6, 0.6) * shot_scale

func _ai_high() -> void:

	if armor <= 0:
		aihigh = ai_high.NONE
		aimid = ai_mid.NONE
		ailow = ai_low.NONE

	target_hot = false

	match aihigh:
		ai_high.R1:
			aimid = ai_mid.ROCKET
			ailow = ai_low.NONE
		ai_high.B1:
			aimid = ai_mid.BOMB
			ailow = ai_low.NONE
		ai_high.M1:
			aimid = ai_mid.NONE
			ailow = ai_low.NONE
			if missile_clock > 5 && missile_clock < lifespan - 5:
				aimid = ai_mid.INTERCEPT

func _ai_mid() -> void:
	var d := 0.0
	match aimid:
		ai_mid.ROCKET:

			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
				d = pos.distance_to(target_pos)

				if d < detonate_range:
					armor = -100

			if missile_clock > 5:
				_do_command(commands.THRUST)
				_do_smoke()

			ailow = ai_low.NONE
		ai_mid.BOMB:

			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
				d = pos.distance_to(target_pos)

				if d < detonate_range:
					armor = -100

			if missile_clock > 3 && missile_clock < 10:
				_do_command(commands.THRUST)
				_do_smoke()

			ailow = ai_low.NONE
		ai_mid.INTERCEPT:
			#TODO: Implement Lead Collision
			
			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
				d = pos.distance_to(target_pos)

				if d < detonate_range:
					armor = -100

				ailow = ai_low.CHARGE
				_do_smoke()

			else:
				ailow = ai_low.NONE
		