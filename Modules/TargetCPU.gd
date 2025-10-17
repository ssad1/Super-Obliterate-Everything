class_name TargetCPU
extends Node

var up

var targets = []
		
var target_clock:int = 1
var target_i:int = -1
#var target_d = 0
var target_pos:Vector2 = Vector2(0,0)
var target_velocity:Vector2 = Vector2(0,0)
var target_profile:String = "NORMAL"

#var scan_type:int = 1
var scan_range:int = 10000
var scan_ships:bool = false
var scan_structs:bool = false
var scan_rocks:bool = false
var scan_shots:bool = false
var scan_missiles:bool = false
var scan_ally:bool = false
var scan_neutral:bool = false
var scan_enemy:bool = false
var scan_injured:bool = false
var scan_special_only:bool = false
var scan_special:String = ""

var found_victim:bool = false
var target_in_range: bool = false

var set_target_profile = target_profile : 
	get:
		return target_profile
	set(value):
		target_profile = value
		_do_profile()

func _ready():
	up = get_parent()
	up.tcpu = self

func _clean_target(s) -> void:

	var i := targets.size() - 1

	while i >= 0:
		var target = targets[i] 
		if "spawn_id" in target && target.spawn_id == s:
			targets.remove_at(i)
			i = 0
		i = i - 1

func _clean_targets() -> void:

	for i in range(targets.size() - 1, -1, -1):

		var target = targets[i]
		if !check_target(target): 
			targets.remove_at(i)
			continue

func check_target(target) -> bool:

	if target == null || !is_instance_valid(target) || !("armor" in target && "cloaked" in target && "player" in target):
		return false

	target_pos = target.pos

	var dist := pow((target_pos.x - up.pos.x),2) + pow((target_pos.y - up.pos.y),2)
	var scan_d := scan_range * scan_range

	if (
	target.spawn_id == up.spawn_id || 
	target.armor <= 0 || 
	target.cloaked == true ||
	target.visible == false ||
	dist > scan_d):
		return false

	#check which faction we are in

	if target.player != null && up.player != null: #initial check to not crash the whole thing

		var diplo = DIPLOMACY.grid[target.player.id][up.player.id]

		if (
		!scan_enemy && diplo == 0 || 
		!scan_neutral && diplo == 1 || 
		!scan_ally && diplo == 2):
			return false
		
	#miners, metalporters, etc

	if (
	(scan_special_only && target.special != scan_special) ||
	(!scan_rocks && target.special == "ROCK") ||
	(scan_injured && target.armor >= target.max_armor)):
		return false

	return true

func _do_tick():
	
	#make sure we ALWAYS have something to target no matter what

	if target_clock == 0 && !found_victim:
		
		_do_scan()

		target_clock = 4
	else:
		target_clock = target_clock - 1

func _do_profile() -> void:
	scan_ships = false
	scan_structs = false
	scan_rocks = false
	scan_shots = false
	scan_missiles = false
	scan_ally = false
	scan_neutral = false
	scan_enemy = false
	scan_special_only = false
	match target_profile:
		"NORMAL":
			scan_ships = true
			scan_structs = true
			scan_enemy = true
		"BOMBER":
			scan_structs = true
			scan_enemy = true
		"PHALANX":
			scan_shots = true
			scan_missiles = true
			scan_enemy = true
		"MINER_MINE":
			scan_structs = true
			scan_rocks = true
			scan_neutral = true
			scan_special_only = true
			scan_special = "ROCK"
		"MINER_RETURN":
			scan_ally = true
			scan_structs = true
			scan_special_only = true
			scan_special = "EXTRACTOR"
		"EXPLOSION":
			scan_ships = true
			scan_structs = true
			scan_missiles = false
			scan_rocks = true
			scan_ally = true
			scan_enemy = true
			scan_neutral = true
		"STATION":
			scan_ally = true
			scan_structs = true
			scan_special_only = true
			scan_special = "STATION"
		"REPAIR":
			scan_ally = true
			scan_injured = true
			scan_ships = true
			scan_structs = true

#to immediately search for something else and attack it

func _do_scan():

	if found_victim:
		return

	var stuff
	targets = []

	if scan_structs == true:
		stuff = SPAWNER.game.structs
		for i in stuff.size():
			targets.append(stuff[i])
	if scan_ships == true:
		stuff = SPAWNER.game.ships
		for i in stuff.size():
			targets.append(stuff[i])
	if scan_missiles == true:
		stuff = SPAWNER.game.missiles
		for i in stuff.size():
			targets.append(stuff[i])
	if scan_shots == true:
		stuff = SPAWNER.game.shots
		for i in stuff.size():
			targets.append(stuff[i])
		
	if "target_hot" in up:
		found_victim = up.target_hot

	#to not waste resources with trivial units/objects
	if up.is_type == "STRUCT" || up.is_type == "SHOT" || up.is_type == "LASER": 
		found_victim = true

	_clean_targets()

#to attack whatever entered in the range

func _do_FOV_entered(obj: Area2D) -> void:

	#make sure we got a valid object in our FOV

	if not obj is unit_hitbox: pass

	var unit := obj as unit_hitbox

	if unit == null || not "is_type" in unit.parent_unit: 
		return

	var parent := unit.parent_unit

	if !check_target(parent): return

	if parent.is_type == "STRUCT" && scan_structs:
		targets.append(parent)
		target_in_range = true
	if parent.is_type == "SHIP" && scan_ships:
		targets.append(parent)
		target_in_range = true
	if parent.is_type == "MISSILE" && scan_missiles:
		targets.append(parent)
		target_in_range = true
	if parent.is_type == "SHOT" && scan_shots:
		targets.append(parent)
		target_in_range = true

	if "target_hot" in up:
		found_victim = up.target_hot

	if up.is_type == "STRUCT" || up.is_type == "SHOT" || up.is_type == "LASER": 
		found_victim = true
		
	'''
	var parentu = up as Thing

	for target in targets:

		if is_instance_valid(target) && is_instance_valid(parentu) && target_clock == 0: 
			print("\nThe up's name: ", parentu.name_text)
			print("The up's path: ", parentu.scene_file_path)
			print("The up's tree path: ", parentu.get_path())
			print("The target's path: ", target.name_text)
			print("The target's path: ", target.scene_file_path)
			print("The target's tree path: ", target.get_path())'''

func _do_FOV_exited(obj: Area2D):
	#make sure we got a valid object in our FOV

	if not obj is unit_hitbox: pass

	var unit := obj as unit_hitbox

	if unit == null || not "is_type" in unit.parent_unit: 
		return

	var parent := unit.parent_unit

	if !check_target(parent): return

	if targets.size() == 0: target_in_range = false

func _target_closest(our_pos) -> int:
	var old_d := 100000
	var old_i := 0
	var d:float
	var pos:Vector2
	var ret := -1
	_clean_targets()
	for i in targets.size():

		if not is_instance_valid(targets[i]) && "pos" in targets[i]: continue

		pos = targets[i].pos
		d = sqrt(pow((our_pos.x - pos.x),2) + pow((our_pos.y - pos.y),2))

		if d < old_d:
			old_i = i
			old_d = d
	
	if old_d < 100000:
		target_i = old_i
		#target_d = old_d
		target_pos = targets[target_i].pos
		target_velocity = targets[target_i].velocity
		ret = target_i
	return ret
