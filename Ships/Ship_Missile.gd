class_name Ship_Missile
extends Ship_General

@export var lifespan:int = 20
@export var detonate_range:int = 16
var missile_clock:int = 0
@export var shot_scale:float = 1
@export var damage:float = 1
@export var force:float = 1
@export var smoke_trail:int = 0

func _ready() -> void:
	_init_missile()

func _init_missile() -> void:
	scale = shot_scale * Vector2(1,1)
	armor = max_armor
	is_type = "MISSILE"
	_do_range()
	#_do_shader(0)

func _do_tick() -> void:
	scale = shot_scale * Vector2(1,1)
	missile_clock = missile_clock + 1
	if missile_clock >= lifespan:
		#print("BOOM TIME")
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
		aihigh = ""
		aimid = ""
		ailow = ""

	target_hot = false

	match aihigh:
		"R1":
			aimid = "ROCKET"
			ailow = ""
		"B1":
			aimid = "BOMB"
			ailow = ""
		"M1":
			aimid = ""
			ailow = ""
			if missile_clock > 5 && missile_clock < lifespan - 5:
				aimid = "INTERCEPT"

func _ai_mid() -> void:
	var d := 0.0
	match aimid:
		"ROCKET":

			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
				d = pos.distance_to(target_pos)

				if d < detonate_range:
					armor = -100

			if missile_clock > 5:
				_do_command("THRUST")
				_do_smoke()

			ailow = ""
		"BOMB":

			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
				d = pos.distance_to(target_pos)

				if d < detonate_range:
					armor = -100

			if missile_clock > 3 && missile_clock < 10:
				_do_command("THRUST")
				_do_smoke()

			ailow = ""
		"INTERCEPT":
			#TODO: Implement Lead Collision
			
			if tcpu._target_closest(pos) != -1:
				target_pos = tcpu.target_pos
				target_velocity = tcpu.target_velocity
				target_hot = true
				d = pos.distance_to(target_pos)

				if d < detonate_range:
					armor = -100

				ailow = "CHARGE"
				_do_smoke()

			else:
				ailow = ""
			
