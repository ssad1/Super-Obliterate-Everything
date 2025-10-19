extends Node

var id:int = 0
var faction:int = 0
var flag_color:Color = Color(255,255,255)
var light_color:Color = Color(255,255,255)

var me:bool = false
var dead:bool = false
var cpu:bool = false
var variant:int = 0
var ai_reaction:int = 10
var ai_no_rocks:bool = false
var ai_mining:bool = false
var ai_base:int = 0
var ai_reactor:int = 1
var ai_extractor:int = 2
var ai_turret_a:int = 3
var ai_turret_b:int = 4
var ai_turret_c:int = 5
var ai_ship_a:int = 6
var ai_ship_b:int = 7
var ai_ship_c:int = 8
var ai_ship_d:int = 9
var ai_defense:int = 10
var ai_reactor_score:int = 0
var ai_extractor_score:int = 0
var ai_economy_score:int = 0
var ai_defense_score:int = 0
var ai_offense_score:int = 0
var ai_turret_a_score:int = 0
var ai_turret_b_score:int = 0
var ai_turret_c_score:int = 0
var ai_ship_a_score:int = 0
var ai_ship_b_score:int = 0
var ai_ship_c_score:int = 0
var ai_ship_d_score:int = 0
var ai_difficulty:float = 1
var ai_offense_coeff:int = 1
var ai_defense_coeff:int = 1
var ai_economy_coeff:int = 1
var ai_ship_d_threshold:int = 30

var item_bag:Array = []
var item_bag_objs:Array = []
var item_bag_factory_objs:Array = []

var my_structs:Array = []
var my_stations:Array = []
var my_extractors:Array = []

var _energy_amount:float = 500
var _metal_amount:float = 0
var _supply_amount:float = 100

var energy:float = _energy_amount:
	get:
		return _energy_amount
	set(value):
		_energy_amount = value
		if _energy_amount > 1000:
			_energy_amount = 1000
		if me:
			EVENTS.emit_signal("ui_energy", _energy_amount)

var metal:float = _metal_amount:
	get:
		return _metal_amount
	set(value):
		_metal_amount = value
		if _metal_amount > 1000:
			_metal_amount = 1000
		if me:
			EVENTS.emit_signal("ui_metal", _metal_amount)

var supply:float = _supply_amount:
	get:
		return _supply_amount
	set(value):
		_supply_amount = value
		if _supply_amount > 1000:
			_supply_amount = 1000
		if me:
			EVENTS.emit_signal("ui_supply",_supply_amount)

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

func _add_resource(e:float, m:float, s:float) -> void:
	var difficulty_coeff = 0
	if !cpu:
		energy = energy + e
		metal = metal + m
		supply = supply + s
	else:
		difficulty_coeff = .75 * (.2 * (ai_difficulty - 1) + 1)
		energy = energy + difficulty_coeff * float(e)
		metal = metal + difficulty_coeff * float(m)
		supply = supply + s

func _build(moves:Array) -> void:
	var obj
	var pa := Vector2(0,0)
	var build_station
	var station_id := -1

	if moves[2] > item_bag_objs.size(): return
	if item_bag_objs[moves[2]] == null: return

	var s = item_bag_objs[moves[2]]

	if energy < s.energy_cost || metal < s.metal_cost || supply < s.supply_cost: return

	pa = Vector2(32 * moves[3],32 * moves[4])
	station_id = _find_closest_station(pa)
	
	if station_id != -1:

		build_station = my_stations[station_id]
		obj = SPAWNER._spawn([2500], id, build_station.pos, Vector2(0,0), 0, 0, 1)
		obj.build_mission = moves
		obj._init_builder()
		obj._add_payload(s.energy_cost,s.metal_cost,s.supply_cost)
		EVENTS.emit_signal("build_line",obj,obj.target_pos)
		EVENTS.emit_signal("build_spot_ghost",obj)
		
	energy = energy - s.energy_cost
	metal = metal - s.metal_cost
	supply = supply - s.supply_cost
	#SPAWNER._spawn(item_bag[rx_moves[i][2]], rx_moves[i][0], Vector2(32 * rx_moves[i][3], 32 * rx_moves[i][4]), Vector2(0,0), 0, 0)

func _buildability(spot:Vector2, build_size:Vector2, mode:int) -> bool:
	for xx in range(spot.x, spot.x + build_size.x):

		var radar:Array = SPAWNER.game.radar

		for yy in range(spot.y, spot.y + build_size.y):

			if xx < 0 || xx >= radar.size() || yy < 0 || yy >= radar[xx].size():
				return false
			if mode == 0 && radar[xx][yy] != 0 || mode == 1 && radar[xx][yy] == 1:
				return false

	return true

func _build_struct(moves:Array, override:bool) -> bool:
	var build_size := Vector2(0,0)

	if "factory" in item_bag_objs[moves[2]]:
		build_size = item_bag_factory_objs[moves[2]].build_size
	else:
		build_size = item_bag_objs[moves[2]].build_size

	var build := _buildability(Vector2(moves[3],moves[4]),build_size,1)

	if !build && !override: return build

	var pos := Vector2(32 * moves[3], 32 * moves[4])
	var obj

	if "factory" in item_bag_objs[moves[2]]:
		obj = SPAWNER._spawn([item_bag_objs[moves[2]].factory], id, pos, Vector2(0,0), 0, 0, 1)
		_setup_factory(moves[2],obj)
	else:
		obj = SPAWNER._spawn(item_bag[moves[2]], id, pos, Vector2(0,0), 0, 0, 1)

	SPAWNER.game._do_radar()

	return build

func _check_dead() -> void:
	var s:Array = SPAWNER.game.structs
	dead = true
	for i in s.size():
		if s[i].player == self:
			dead = false

func _do_ai() -> void:

	var command := [0,0,0,0]
	var build_size := Vector2(0,0)
	var output
	var ai_struct := 0
	var location := Vector2(0,0)

	if ai_reaction == 0:

		#Calculate Scores
		#Check items vs Scores
		#Select best item
		#Select ideal location

		ai_struct = _do_ai_priority()
		build_size = _get_build_size(ai_struct)

		if ai_struct == ai_reactor:
			location = _do_ai_reactor_spot()
		if ai_struct == ai_extractor:
			location = _do_ai_mining_spot()
		if ai_struct == ai_turret_a || ai_struct == ai_turret_b || ai_struct == ai_turret_c:
			location = _do_ai_turret_spot("ENEMY")
		if ai_struct == ai_ship_a || ai_struct == ai_ship_b || ai_struct == ai_ship_c || ai_struct == ai_ship_d:
			location = _do_ai_offense_spot()

		output = _do_ai_spiral(location,build_size)

		if output != null:
			command = [1,ai_struct,output.x,output.y]

		_do_ai_command(command)
		ai_reaction = 10
	else:
		ai_reaction = ai_reaction - 1

func _do_ai_command(command:Array) -> void:
	var spot := Vector2(0,0)
	
	if command[0] == 1: #command_type, build_id, x, y
		EVENTS.emit_signal("do_move",id,1,command[1],command[2],command[3])

func _do_ai_defense() -> int:

	var scores := [ai_turret_a_score, 3 * ai_turret_b_score + 3, 9 * ai_turret_c_score + 9]
	var picked := 0
	var old_d := 10000
	var s:int

	if ai_mining:
		for i in scores.size():
			if scores[i] < old_d:
				picked = i
				old_d = scores[i]
		match picked:
			0:
				return ai_turret_a
			1:
				return ai_turret_b
			2:
				return ai_turret_c

	return ai_turret_a

func _do_ai_economy() -> int:

	if !ai_no_rocks && ai_extractor_score < ai_reactor_score / 3:
		return ai_extractor

	return ai_reactor

func _do_ai_offense() -> int:

	var scores := [ai_ship_a_score, 2 * ai_ship_b_score + 3, 2 * ai_ship_c_score + 5, 3 * ai_ship_d_score + 7]
	var picked := 0
	var old_d := 10000
	var d_score = ai_defense_score

	if d_score > 10:
		d_score = 10

	if ai_mining:
		for i in scores.size():
			if scores[i] < old_d:
				picked = i
				old_d = scores[i]
		if ai_offense_score + ai_defense_score + ai_economy_score > ai_ship_d_threshold:
			picked = 3
		match picked:
			0:
				return ai_ship_a
			1:
				return ai_ship_b
			2:
				return ai_ship_c
			3:
				return ai_ship_d

	return ai_ship_a

func _do_ai_offense_spot() -> Vector2:

	var station_pos := Vector2(0,0)
	var spot := Vector2(0,0)

	for i in my_structs.size():
		spot = spot + my_structs[i].pos / my_structs.size()

	spot = Vector2(floor(spot.x / 32),floor(spot.y / 32))
	#if(my_stations.size() > 0):
	#	station_pos = my_stations[0].pos / 32
	#	spot.x = floor(station_pos.x - 4 + 8.9 * CALC._rand())
	#	spot.y = floor(station_pos.y - 4 + 8.9 * CALC._rand())
	return spot

func _do_ai_priority() -> int:

	var scores := [ai_economy_score * ai_economy_coeff, ai_defense_score * ai_defense_coeff, ai_offense_score * ai_offense_coeff]
	var picked := 0
	var old_d := 10000
	var s

	for i in scores.size():
		if scores[i] < old_d:
			picked = i
			old_d = scores[i]

	match picked:
		0:
			s = _do_ai_economy()
		1:
			s = _do_ai_defense()
		2:
			s = _do_ai_offense()
	return s
			
func _do_ai_reactor_spot() -> Vector2:

	var station_pos := Vector2(0,0)
	var center:Vector2 = (SPAWNER.game.mapsize / 32) / 2
	var rdir := Vector2(0,0)

	if my_stations.size() > 0:
		station_pos = my_stations[0].pos / 32

	rdir = center - station_pos
	rdir = rdir.normalized()
	rdir = Vector2(round(rdir.x * -4),round(rdir.y * -4)) + station_pos
	rdir.x = rdir.x - 4 + floor(CALC._rand() * 8.9)
	rdir.y = rdir.y - 4 + floor(CALC._rand() * 8.9)

	return rdir

func _do_ai_spiral(p:Vector2, build_size:Vector2):

	var output = null
	var dir:int = floor(CALC._rand() * 3.99)
	var clockwise := 1.0
	var steps := 0.0
	#var i = 0
	var j := 0.0
	var searching := true
	var timeout := 20
	var spot := p

	if CALC._rand() < 0.5:
		clockwise = -1
	
	while searching && timeout > 0:

		if timeout % 2 == 0:
			steps = steps + 1
		j = 0

		while searching && j < steps:

			#print(str(dir) + " " + str(j) + " " + str(steps) + " " + str(spot) + " " + str(build_size))
			if _buildability(spot,build_size,0):
				output = spot
				searching = false

			match dir:
				0: #North
					spot.y = spot.y - 1;
				1: #East
					spot.x = spot.x + 1;
				2: #South
					spot.y = spot.y + 1;
				3: #West
					spot.x = spot.x - 1;
			
			j = j + 1

		dir = dir + 1

		if dir < 0:
			dir = dir + 4

		if dir > 3:
			dir = dir - 4

		timeout = timeout - 1
	return output

func _do_ai_mining_spot() -> Vector2:

	var d := 0.0
	var k := 0
	var old_d := 0.0
	var station_d := 100000000.0
	var r
	var inserted := false
	var erase := false
	var rocks := [] #[rock,distance,near]
	var coord := Vector2(0,0)

	#Order rocks by distance

	for i in SPAWNER.game.rocks.size():
		#print(i)
		r = SPAWNER.game.rocks[i]
		station_d = 100000000

		for j in my_stations.size():
			d = my_stations[j].pos.distance_to(r.pos)
			if d < station_d:
				station_d = d

		inserted = false
		k = 0

		while k < rocks.size() && !inserted:
			if station_d < rocks[k][1]:
				rocks.insert(k,[r,station_d,0,0])
				inserted = true
			k = k + 1

		if !inserted:
			rocks.append([r,station_d,0,0])

	#Remove rocks near extractors

	k = rocks.size() - 1
	while k >= 0:
		erase = false

		for j in my_extractors.size():
			d = my_extractors[j].pos.distance_to(rocks[k][0].pos)
			if d < 100:
				erase = true

		if erase:
			rocks.remove_at(k)

		k = k - 1

	#Shorten the list. Remove the furthest

	k = rocks.size() - 1

	while k >= 0:
		if k >= 20:
			rocks.remove_at(k)
		k = k - 1

	#Nearby rocks and Calculate score

	for i in rocks.size():

		var rock_i = rocks[i]

		for j in SPAWNER.game.rocks.size():
			r = SPAWNER.game.rocks[j]

			if rock_i[0].spawn_id != r.spawn_id:
				d = rocks[i][0].pos.distance_to(r.pos)
				if d < 200:
					rock_i[2] = rock_i[2] + r.max_armor - .05 * d
		rock_i[3] = rock_i[3] + 2 * rock_i[0].max_armor
		rock_i[3] = -1 * rock_i[1] + rock_i[2]

	#Find highest score

	old_d = 0
	k = 0

	for i in rocks.size():
		d = rocks[i][3]
		if d > old_d:
			old_d = d
			k = i

	if rocks.size() != 0:
		r = rocks[k][0]
		coord = Vector2(round(r.pos.x / 32),round(r.pos.y / 32))
	else:
		ai_no_rocks = true
		coord = Vector2(my_stations[0].pos.x,my_stations[0].pos.y)

	return coord

func _do_ai_turret_spot(mode:String) -> Vector2:

	var j := 0
	var d := 0.0
	var old_d := 0.0
	var closest := -1
	var closest_enemy := -1
	var enemies := []
	var center:Vector2 = (SPAWNER.game.mapsize / 32) / 2
	var struct_pos := Vector2(0,0)
	var spot := Vector2(0,0)
	var spotb := Vector2(0,0)
	var rdir := Vector2(0,0)

	match mode:
		"PERIMETER":
			d = CALC._rand() * 2 * PI
			j = 14

			for i in my_structs.size():
				if my_structs[i].special == "STATION":
					spotb = my_structs[i].pos / 32
					#spotb.y = my_structs[i].pos.y / 32

			spot.x = j * cos(d) + spotb.x - 2 + 4 * CALC._rand()
			spot.y = j * sin(d) + spotb.y - 2 + 4 * CALC._rand()

		"CENTER":
			old_d = 10000000

			for i in my_structs.size():
				if my_structs[i].class_text == "TURRET": continue
				d = my_structs[i].pos.distance_to(center * 32)
				if d < old_d:
					old_d = d
					closest = i

			if closest != -1:
				struct_pos = my_structs[closest].pos / 32
				rdir = center - struct_pos
				rdir = rdir.normalized()
				spot = struct_pos + 5 * rdir
				spot.x = spot.x - 3 + 6 * CALC._rand()
				spot.y = spot.y - 3 + 6 * CALC._rand()

		"ENEMY":
			for i in SPAWNER.game.structs.size():
				var s = SPAWNER.game.structs[i]
				if DIPLOMACY.grid[id][s.player.id] == 0:
					enemies.append(s)
			old_d = 10000000

			for i in my_structs.size():
				if my_structs[i].class_text == "TURRET": continue
				for k in enemies.size():
					d = my_structs[i].pos.distance_to(enemies[k].pos)
					if d < old_d:
						old_d = d
						closest = i
						closest_enemy = k

			if closest != -1:
				struct_pos = my_structs[closest].pos / 32
				rdir = enemies[j].pos - struct_pos
				rdir = rdir.normalized()
				spot = struct_pos + 5 * rdir
				spot.x = spot.x - 3 + 6 * CALC._rand()
				spot.y = spot.y - 3 + 6 * CALC._rand()

	spot = Vector2(floor(spot.x),floor(spot.y))
	return spot

func _do_event(e:Array) -> void:

	#Type, Start Time, End Time, Clock, Max Clock, Spawn Player, Spawn ID, Spawn Number, Spawn Direction

	var s
	var theta := 0.0
	var posit := Vector2(0,0)

	match e[6]:
		1:
			s = ai_ship_a
		2:
			s = ai_ship_b
		3:
			s = ai_ship_c
		4:
			s = ai_ship_d

	theta = e[8]

	if e[8] == 0:
		theta = CALC._rand() * 2 * PI

	posit = Vector2(SPAWNER.game.mapsize.x / 2 + 1500 * cos(theta), SPAWNER.game.mapsize.y / 2 + 1500 * sin(theta))
	SPAWNER._spawn(item_bag[s], id, posit, Vector2(0,0),0,0,0)

func _do_tick() -> void:
	_find_stuff()

	if SPAWNER.game.rocks.size() > 0:
		ai_no_rocks = false
	else:
		ai_no_rocks = true

	_check_dead()

	if cpu:
		_do_ai()

func _find_stuff() -> void:

	var structs = SPAWNER.game.structs
	my_structs = []
	my_stations = []
	my_extractors = []
	ai_reactor_score = 0
	ai_economy_score = 0
	ai_defense_score = 0
	ai_offense_score = 0
	ai_turret_a_score = 0
	ai_turret_b_score = 0
	ai_turret_c_score = 0
	ai_ship_a_score = 0
	ai_ship_b_score = 0
	ai_ship_c_score = 0
	ai_ship_d_score = 0

	for i in structs.size():

		var struct = structs[i]

		if struct.player != self: continue

		my_structs.append(struct)

		if struct.special == "STATION":
			my_stations.append(struct)
		if struct.special == "EXTRACTOR":
			my_extractors.append(struct)
			ai_economy_score = ai_economy_score + 2
		if struct.special == "REACTOR":
			ai_reactor_score = ai_reactor_score + 1
			ai_economy_score = ai_economy_score + 1
		if struct.special == "OFFENSE":
			ai_offense_score = ai_offense_score + struct.build_size.y * 2 - 1

		if item_bag.size() > 0:

			if struct.s == item_bag[ai_turret_a]:
				ai_turret_a_score = ai_turret_a_score + 1
			if struct.s == item_bag[ai_turret_b]:
				ai_turret_b_score = ai_turret_b_score + 1
			if struct.s == item_bag[ai_turret_c]:
				ai_turret_c_score = ai_turret_c_score + 1

			var ship = struct._get_ship()

			if item_bag[ai_ship_a] != null && ship == item_bag[ai_ship_a][0]:
				ai_ship_a_score = ai_ship_a_score + 1
			if item_bag[ai_ship_b] != null && ship == item_bag[ai_ship_b][0]:
				ai_ship_b_score = ai_ship_b_score + 1
			if item_bag[ai_ship_c] != null && ship == item_bag[ai_ship_c][0]:
				ai_ship_c_score = ai_ship_c_score + 1
			if item_bag[ai_ship_d] != null && ship == item_bag[ai_ship_d][0]:
				ai_ship_d_score = ai_ship_d_score + 1

		ai_defense_score = ai_defense_score + struct._get_turret_score()

	ai_extractor_score = my_extractors.size()
	ai_mining = false

	if my_extractors.size() > 0 && !ai_no_rocks:
		ai_mining = true

func _find_closest_station(pa:Vector2) -> int:

	var d := 0.0
	var old_d := 10000.0
	var s := -1
	var pb := Vector2(0,0)

	for i in my_stations.size():

		pb = my_stations[i].pos

		d = pb.distance_to(pa)
		if d < old_d:
			s = i

	return s

func _get_build_size(s) -> Vector2:

	if "factory" in item_bag_objs[s]:
		return item_bag_factory_objs[s].build_size

	return item_bag_objs[s].build_size

func _set_faction(f:int, v:int) -> void:
	faction = f
	variant = v
	item_bag = FACTIONS._faction_items(f,v)
	_set_color(f)
	_set_item_bag()

func _set_color(f:int) -> void:
	var c = FACTIONS._faction_colors(f)
	flag_color = c[0]
	light_color = c[1]

func _set_item_bag() -> void:
	var obj
	var j := item_bag_objs.size() - 1

	while j > -1:
		if weakref(item_bag_objs[j]).get_ref() != null:
			item_bag_objs[j].queue_free()
		j = j - 1

	item_bag_objs = []
	j = item_bag_factory_objs.size() - 1

	while j > -1:
		if weakref(item_bag_factory_objs[j]).get_ref() != null:
			item_bag_factory_objs[j].queue_free()
		j = j - 1
	
	item_bag_factory_objs = []

	for i in item_bag.size():
		if item_bag[i] != null:
			obj = SPAWNER._spawn(item_bag[i],id,Vector2(0,0),Vector2(0,0),0,13,0)
			item_bag_objs.append(obj)

			if "factory" in obj:
				item_bag_factory_objs.append(SPAWNER._spawn([obj.factory],id,Vector2(0,0),Vector2(0,0),0,13,0))
			else:
				item_bag_factory_objs.append(null)
		else:
			item_bag_objs.append(null)
			item_bag_factory_objs.append(null)

func _set_me_player() -> void:
	me = true
	SPAWNER.game.me = self
	item_bag = []
	item_bag.append([200])

	var current_equip = ACCOUNT.equip_bags[ACCOUNT.current_equip]

	for i in current_equip.size():
		if current_equip[i] != null:
			item_bag.append(ACCOUNT.item_bag[current_equip[i]])
		else:
			item_bag.append(null)
	
	_set_item_bag()
	EVENTS.emit_signal("equip",item_bag)

func _set_cpu(d:float) -> void:
	cpu = true
	ai_difficulty = d

	if CALC._randint() % 10 > 7:
		ai_defense_coeff = 2
	if CALC._randint() % 10 > 7:
		ai_offense_coeff = 2
	if CALC._randint() % 10 > 7:
		ai_economy_coeff = 2

	ai_ship_d_threshold = 30 + 30 * CALC._randint()

func _setup_factory(s,obj) -> void:
	for i in obj.modules.size():
		if obj.modules[i].name == "Hangar_Factory":
			obj.modules[i].ship_id = item_bag[s]

func _setup_base() -> void:
	var mode := 0
	var location:Vector2
	var d := 0

	if variant == 1:
		mode = 1
	if LEVELS.level_mission == "DEFENSE":
		mode = 2

	_find_stuff()
	match mode:
		0: #Standard
			d = ai_difficulty
			for i in d:
				location = _do_ai_turret_spot("CENTER")

				if i < 5:
					_build_struct([id,1,ai_turret_a,location.x,location.y],false)
				else:
					_build_struct([id,1,ai_turret_b,location.x,location.y],false)

				if i > 3 && i % 2 == 0:
					location = _do_ai_turret_spot("CENTER")
					_build_struct([id,1,ai_defense,location.x,location.y],false)
		1: #Boss
			energy = energy + 300
			ai_difficulty = ai_difficulty + .1
			d = 2 * ai_difficulty + 3
			#location = _do_ai_turret_spot("CENTER")
			#_build_struct([id,1,ai_ship_b,location.x,location.y],false)
			for i in d:
				location = _do_ai_turret_spot("CENTER")

				if i < 5:
					_build_struct([id,1,ai_turret_a,location.x,location.y],false)
				else:
					_build_struct([id,1,ai_turret_b,location.x,location.y],false)

				if i > 3 && i % 2 == 0:
					location = _do_ai_turret_spot("CENTER")
					_build_struct([id,1,ai_defense,location.x,location.y],false)

			for i:int in 15 + ai_difficulty:
				location = _do_ai_turret_spot("PERIMETER")

				if i < 10:
					_build_struct([id,1,ai_turret_a,location.x,location.y],false)
				else:
					_build_struct([id,1,ai_turret_b,location.x,location.y],false)

				if i > 3 && i % 2 == 0:
					location = _do_ai_turret_spot("PERIMETER")
					_build_struct([id,1,ai_defense,location.x,location.y],false)
		2: #Defense
			pass

func _setup_station() -> void:
	print("Setup Station")
	print(id)
	#print(LEVELS.spots[id - 1])
	#TODO ERROR HERE
	if id - 1 < LEVELS.spots.size():
		_build_struct([id,1,ai_base,LEVELS.spots[id - 1].x,LEVELS.spots[id - 1].y],true)
		_find_stuff()

func _setup_resources(s:String) -> void:
	supply = 100
	match s:
		"STANDARD":
			energy = 500
			metal = 0
		"HIGH ENERGY":
			energy = 1000
			metal = 0
		"STOCKPILE":
			energy = 1000
			metal = 1000
		"HEAVY METAL":
			energy = 350
			metal = 700
		"MIXED START":
			energy = 500
			metal = 200
