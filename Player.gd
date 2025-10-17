extends Node

var id = 0
var faction = 0
var flag_color = Color(255,255,255)
var light_color = Color(255,255,255)

var energy = 500
var metal = 0
var supply = 100

var me = false
var dead = false
var cpu = false
var variant = 0
var ai_reaction = 10
var ai_no_rocks = false
var ai_mining = false
var ai_base = 0
var ai_reactor = 1
var ai_extractor = 2
var ai_turret_a = 3
var ai_turret_b = 4
var ai_turret_c = 5
var ai_ship_a = 6
var ai_ship_b = 7
var ai_ship_c = 8
var ai_ship_d = 9
var ai_defense = 10
var ai_reactor_score = 0
var ai_extractor_score = 0
var ai_economy_score = 0
var ai_defense_score = 0
var ai_offense_score = 0
var ai_turret_a_score = 0
var ai_turret_b_score = 0
var ai_turret_c_score = 0
var ai_ship_a_score = 0
var ai_ship_b_score = 0
var ai_ship_c_score = 0
var ai_ship_d_score = 0
var ai_difficulty = 1
var ai_offense_coeff = 1
var ai_defense_coeff = 1
var ai_economy_coeff = 1
var ai_ship_d_threshold = 30

var item_bag = []
var item_bag_objs = []
var item_bag_factory_objs = []

var my_structs = []
var my_stations = []
var my_extractors = []

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _add_resource(e,m,s):
	var difficulty_coeff = 0
	if(cpu == false):
		energy = energy + e
		metal = metal + m
		supply = supply + s
	else:
		difficulty_coeff = .75 * (.2 * (ai_difficulty - 1) + 1)
		energy = energy + difficulty_coeff * float(e)
		metal = metal + difficulty_coeff * float(m)
		supply = supply + s

func _build(moves):
	var s
	var obj
	var build = true
	var pa := Vector2(0,0)
	var build_station
	var station_id = -1
	if moves[2] < item_bag_objs.size():
		if item_bag_objs[moves[2]] != null:
			s = item_bag_objs[moves[2]]
			if(energy < s.energy_cost):
				build = false
			if(metal < s.metal_cost):
				build = false
			if(supply < s.supply_cost):
				build = false
		else:
			build = false
	else:
		build = false
	if build == true:
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

func _buildability(spot,build_size,mode):
	var output = false
	output = true
	for xx in range(spot.x, spot.x + build_size.x):
		for yy in range(spot.y, spot.y + build_size.y):
			if(xx >= 0 && xx < SPAWNER.game.radar.size() && yy >= 0 && yy < SPAWNER.game.radar[xx].size()):
				if(mode == 0 && SPAWNER.game.radar[xx][yy] != 0):
					output = false
				if(mode == 1 && SPAWNER.game.radar[xx][yy] == 1):
					output = false
			else:
				output = false
	return output

func _build_struct(moves, override):
	var s
	var obj
	var build = true
	var build_size := Vector2(0,0)
	if("factory" in item_bag_objs[moves[2]]):
		build_size = item_bag_factory_objs[moves[2]].build_size
	else:
		build_size = item_bag_objs[moves[2]].build_size
	build = _buildability(Vector2(moves[3],moves[4]),build_size,1)
	if build == true || override == true:
		if "factory" in item_bag_objs[moves[2]]:
			obj = SPAWNER._spawn([item_bag_objs[moves[2]].factory], id, Vector2(32 * moves[3], 32 * moves[4]), Vector2(0,0), 0, 0, 1)
			_setup_factory(moves[2],obj)
		else:
			obj = SPAWNER._spawn(item_bag[moves[2]], id, Vector2(32 * moves[3], 32 * moves[4]), Vector2(0,0), 0, 0, 1)
		SPAWNER.game._do_radar()
	return build

func _check_dead():
	var s = SPAWNER.game.structs
	dead = true
	for i in range(s.size()):
		if(s[i].player == self):
			dead = false

func _do_ai():
	var command = [0,0,0,0]
	var build_size := Vector2(0,0)
	var output
	var ai_struct = 0
	var location := Vector2(0,0)
	if(ai_reaction == 0):
		#Calculate Scores
		#Check items vs Scores
		#Select best item
		#Select ideal location
		ai_struct = _do_ai_priority()
		build_size = _get_build_size(ai_struct)
		if(ai_struct == ai_reactor):
			location = _do_ai_reactor_spot()
		if(ai_struct == ai_extractor):
			location = _do_ai_mining_spot()
		if(ai_struct == ai_turret_a || ai_struct == ai_turret_b || ai_struct == ai_turret_c):
			location = _do_ai_turret_spot("ENEMY")
		if(ai_struct == ai_ship_a || ai_struct == ai_ship_b || ai_struct == ai_ship_c || ai_struct == ai_ship_d):
			location = _do_ai_offense_spot()
		output = _do_ai_spiral(location,build_size)
		if(output != null):
			command = [1,ai_struct,output.x,output.y]
		_do_ai_command(command)
		ai_reaction = 10
	else:
		ai_reaction = ai_reaction - 1

func _do_ai_command(command):
	var spot := Vector2(0,0)
	match command[0]:
		1: #command_type, build_id, x, y
			EVENTS.emit_signal("do_move",id,1,command[1],command[2],command[3])

func _do_ai_defense():
	var scores = [ai_turret_a_score, 3 * ai_turret_b_score + 3, 9 * ai_turret_c_score + 9]
	var picked = 0
	var old_d = 10000
	var s
	if ai_mining == true:
		for i in range(scores.size()):
			if(scores[i] < old_d):
				picked = i
				old_d = scores[i]
		match picked:
			0:
				s = ai_turret_a
			1:
				s = ai_turret_b
			2:
				s = ai_turret_c
	else:
		s = ai_turret_a
	return s

func _do_ai_economy():
	var c = 0
	if ai_no_rocks == false:
		if ai_extractor_score < ai_reactor_score / 3:
			c = ai_extractor
		else:
			c = ai_reactor
	else:
		c = ai_reactor
	return c

func _do_ai_offense():
	var scores = [ai_ship_a_score, 2 * ai_ship_b_score + 3, 2 * ai_ship_c_score + 5, 3 * ai_ship_d_score + 7]
	var picked = 0
	var old_d = 10000
	var s
	var d_score = ai_defense_score
	if d_score > 10:
		d_score = 10
	if ai_mining == true:
		for i in scores.size():
			if(scores[i] < old_d):
				picked = i
				old_d = scores[i]
		if(ai_offense_score + ai_defense_score + ai_economy_score > ai_ship_d_threshold):
			picked = 3
		match picked:
			0:
				s = ai_ship_a
			1:
				s = ai_ship_b
			2:
				s = ai_ship_c
			3:
				s = ai_ship_d
	else:
		s = ai_ship_a
	return s

func _do_ai_offense_spot():
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

func _do_ai_priority():
	var scores = [ai_economy_score * ai_economy_coeff, ai_defense_score * ai_defense_coeff, ai_offense_score * ai_offense_coeff]
	var picked = 0
	var old_d = 10000
	var s
	for i in scores.size():
		if(scores[i] < old_d):
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
			
func _do_ai_reactor_spot():
	var station_pos := Vector2(0,0)
	var center = (SPAWNER.game.mapsize / 32) / 2
	var rdir := Vector2(0,0)
	if(my_stations.size() > 0):
		station_pos = my_stations[0].pos / 32
	rdir = center - station_pos
	rdir = rdir.normalized()
	rdir = Vector2(round(rdir.x * -4),round(rdir.y * -4)) + station_pos
	rdir.x = rdir.x - 4 + floor(CALC._rand() * 8.9)
	rdir.y = rdir.y - 4 + floor(CALC._rand() * 8.9)
	return rdir

func _do_ai_spiral(p,build_size):
	var output = null
	var dir = int(floor(CALC._rand() * 3.99))
	var clockwise = 1
	var steps = 0
	var i = 0
	var j = 0
	var searching = true
	var timeout = 20
	var spot := Vector2(0,0)
	if(CALC._rand() < 0.5):
		clockwise = -1
	spot = p
	while(searching == true && timeout > 0):
		if(timeout % 2 == 0):
			steps = steps + 1
		j = 0
		while(searching == true && j < steps):
			#print(str(dir) + " " + str(j) + " " + str(steps) + " " + str(spot) + " " + str(build_size))
			if(_buildability(spot,build_size,0) == true):
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
		if(dir < 0):
			dir = dir + 4
		if(dir > 3):
			dir = dir - 4
		timeout = timeout - 1
	return output

func _do_ai_mining_spot():
	var d = 0
	var k = 0
	var old_d = 0
	var station_d = 100000000
	var r
	var inserted = false
	var erase = false
	var rocks = [] #[rock,distance,near]
	var coord := Vector2(0,0)
	#Order rocks by distance
	for i in SPAWNER.game.rocks.size():
		#print(i)
		r = SPAWNER.game.rocks[i]
		station_d = 100000000
		for j in range(my_stations.size()):
			d = my_stations[j].pos.distance_to(r.pos)
			if(d < station_d):
				station_d = d
		inserted = false
		k = 0
		while (k < rocks.size() && inserted == false):
			if(station_d < rocks[k][1]):
				rocks.insert(k,[r,station_d,0,0])
				inserted = true
			k = k + 1
		if(inserted == false):
			rocks.append([r,station_d,0,0])
	#Remove rocks near extractors
	k = rocks.size() - 1
	while(k >= 0):
		erase = false
		for j in range(my_extractors.size()):
			d = my_extractors[j].pos.distance_to(rocks[k][0].pos)
			if(d < 100):
				erase = true
		if(erase == true):
			rocks.remove_at(k)
		k = k - 1
	#Shorten the list. Remove the furthest
	k = rocks.size() - 1
	while(k >= 0):
		if(k >= 20):
			rocks.remove_at(k)
		k = k - 1
	#Nearby rocks and Calculate score
	for i in rocks.size():
		for j in SPAWNER.game.rocks.size():
			r = SPAWNER.game.rocks[j]
			if(rocks[i][0].spawn_id != r.spawn_id):
				d = rocks[i][0].pos.distance_to(r.pos)
				if(d < 200):
					rocks[i][2] = rocks[i][2] + r.max_armor - .05 * d
		rocks[i][3] = rocks[i][3] + 2 * rocks[i][0].max_armor
		rocks[i][3] = -1 * rocks[i][1] + rocks[i][2]
	#Find highest score
	old_d = 0
	k = 0
	for i in rocks.size():
		d = rocks[i][3]
		if(d > old_d):
			old_d = d
			k = i
	if(rocks.size() != 0):
		r = rocks[k][0]
		coord = Vector2(round(r.pos.x / 32),round(r.pos.y / 32))
	else:
		ai_no_rocks = true
		coord = Vector2(my_stations[0].pos.x,my_stations[0].pos.y)
	return coord

func _do_ai_turret_spot(mode):
	var j = 0
	var d = 0
	var old_d = 0
	var closest = -1
	var closest_enemy = -1
	var enemies = []
	var center = (SPAWNER.game.mapsize / 32) / 2
	var struct_pos := Vector2(0,0)
	var spot := Vector2(0,0)
	var spotb := Vector2(0,0)
	var rdir := Vector2(0,0)
	match mode:
		"PERIMETER":
			d = CALC._rand() * 2 * PI
			j = 14
			for i in my_structs.size():
				if(my_structs[i].special == "STATION"):
					spotb.x = my_structs[i].pos.x / 32
					spotb.y = my_structs[i].pos.y / 32
			spot.x = j * cos(d) + spotb.x - 2 + 4 * CALC._rand()
			spot.y = j * sin(d) + spotb.y - 2 + 4 * CALC._rand()
		"CENTER":
			old_d = 10000000
			for i in my_structs.size():
				if(my_structs[i].class_text != "TURRET"):
					d = my_structs[i].pos.distance_to(center * 32)
					if(d < old_d):
						old_d = d
						closest = i
			if(closest != -1):
				struct_pos = my_structs[closest].pos / 32
				rdir = center - struct_pos
				rdir = rdir.normalized()
				spot = struct_pos + 5 * rdir
				spot.x = spot.x - 3 + 6 * CALC._rand()
				spot.y = spot.y - 3 + 6 * CALC._rand()
		"ENEMY":
			for i in SPAWNER.game.structs.size():
				var s = SPAWNER.game.structs[i]
				if(DIPLOMACY.grid[id][s.player.id] == 0):
					enemies.append(s)
			old_d = 10000000
			for i in my_structs.size():
				if(my_structs[i].class_text != "TURRET"):
					for k in enemies.size():
						d = my_structs[i].pos.distance_to(enemies[k].pos)
						if(d < old_d):
							old_d = d
							closest = i
							closest_enemy = k
			if(closest != -1):
				struct_pos = my_structs[closest].pos / 32
				rdir = enemies[j].pos - struct_pos
				rdir = rdir.normalized()
				spot = struct_pos + 5 * rdir
				spot.x = spot.x - 3 + 6 * CALC._rand()
				spot.y = spot.y - 3 + 6 * CALC._rand()
	spot = Vector2(floor(spot.x),floor(spot.y))
	return spot

func _do_event(e):
	#Type, Start Time, End Time, Clock, Max Clock, Spawn Player, Spawn ID, Spawn Number, Spawn Direction
	var s
	var theta = 0
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
	if(e[8] == 0):
		theta = CALC._rand() * 2 * PI
	posit = Vector2(.5 * SPAWNER.game.mapsize.x + 1500 * cos(theta), .5 * SPAWNER.game.mapsize.y + 1500 * sin(theta))
	SPAWNER._spawn(item_bag[s], id, posit, Vector2(0,0),0,0,0)

func _do_tick():
	_find_stuff()
	if(energy > 1000):
		energy = 1000
	if(metal > 1000):
		metal = 1000
	if(SPAWNER.game.rocks.size() > 0):
		ai_no_rocks = false
	else:
		ai_no_rocks = true
	if(me == true):
		EVENTS.emit_signal("ui_energy",energy)
		EVENTS.emit_signal("ui_metal",metal)
		EVENTS.emit_signal("ui_supply",supply)
	_check_dead()
	if(cpu == true):
		_do_ai()

func _find_stuff():
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
		if(structs[i].player == self):
			my_structs.append(structs[i])
			if(structs[i].special == "STATION"):
				my_stations.append(structs[i])
			if(structs[i].special == "EXTRACTOR"):
				my_extractors.append(structs[i])
				ai_economy_score = ai_economy_score + 2
			if(structs[i].special == "REACTOR"):
				ai_reactor_score = ai_reactor_score + 1
				ai_economy_score = ai_economy_score + 1
			if(structs[i].special == "OFFENSE"):
				ai_offense_score = ai_offense_score + structs[i].build_size.y * 2 - 1
			if(item_bag.size() > 0):
				if(structs[i].s == item_bag[ai_turret_a]):
					ai_turret_a_score = ai_turret_a_score + 1
				if(structs[i].s == item_bag[ai_turret_b]):
					ai_turret_b_score = ai_turret_b_score + 1
				if(structs[i].s == item_bag[ai_turret_c]):
					ai_turret_c_score = ai_turret_c_score + 1
				if(item_bag[ai_ship_a] != null):
					if(structs[i]._get_ship() == item_bag[ai_ship_a][0]):
						ai_ship_a_score = ai_ship_a_score + 1
				if(item_bag[ai_ship_b] != null):
					if(structs[i]._get_ship() == item_bag[ai_ship_b][0]):
						ai_ship_b_score = ai_ship_b_score + 1
				if(item_bag[ai_ship_c] != null):
					if(structs[i]._get_ship() == item_bag[ai_ship_c][0]):
						ai_ship_c_score = ai_ship_c_score + 1
				if(item_bag[ai_ship_d] != null):
					if(structs[i]._get_ship() == item_bag[ai_ship_d][0]):
						ai_ship_d_score = ai_ship_d_score + 1
			ai_defense_score = ai_defense_score + structs[i]._get_turret_score()
	ai_extractor_score = my_extractors.size()
	ai_mining = false
	if(my_extractors.size() > 0 && ai_no_rocks == false):
		ai_mining = true

func _find_closest_station(pa):
	var d = 0
	var old_d = 10000
	var s = -1
	var pb := Vector2(0,0)
	for i in my_stations.size():
		pb = my_stations[i].pos
		d = pb.distance_to(pa)
		if(d < old_d):
			s = i
	return s

func _get_build_size(s):
	var output := Vector2(0,0)
	if("factory" in item_bag_objs[s]):
		output = item_bag_factory_objs[s].build_size
	else:
		output = item_bag_objs[s].build_size
	return output

func _set_faction(f,v):
	faction = f
	variant = v
	item_bag = FACTIONS._faction_items(f,v)
	_set_color(f)
	_set_item_bag()

func _set_color(f):
	var c
	c = FACTIONS._faction_colors(f)
	flag_color = c[0]
	light_color = c[1]

func _set_item_bag():
	var obj
	var j = 0
	j = item_bag_objs.size() - 1
	while j > -1:
		if(weakref(item_bag_objs[j]).get_ref() != null):
			item_bag_objs[j].queue_free()
		j = j - 1
	item_bag_objs = []
	j = item_bag_factory_objs.size() - 1
	while j > -1:
		if(weakref(item_bag_factory_objs[j]).get_ref() != null):
			item_bag_factory_objs[j].queue_free()
		j = j - 1
	item_bag_factory_objs = []
	for i in item_bag.size():
		if(item_bag[i] != null):
			obj = SPAWNER._spawn(item_bag[i],id,Vector2(0,0),Vector2(0,0),0,13,0)
			item_bag_objs.append(obj)
			if("factory" in obj):
				item_bag_factory_objs.append(SPAWNER._spawn([obj.factory],id,Vector2(0,0),Vector2(0,0),0,13,0))
			else:
				item_bag_factory_objs.append(null)
		else:
			item_bag_objs.append(null)
			item_bag_factory_objs.append(null)

func _set_me_player():
	me = true
	SPAWNER.game.me = self
	item_bag = []
	item_bag.append([200])
	for i in ACCOUNT.equip_bags[ACCOUNT.current_equip].size():
		if(ACCOUNT.equip_bags[ACCOUNT.current_equip][i] != null):
			item_bag.append(ACCOUNT.item_bag[ACCOUNT.equip_bags[ACCOUNT.current_equip][i]])
		else:
			item_bag.append(null)
	_set_item_bag()
	EVENTS.emit_signal("equip",item_bag)

func _set_cpu(d):
	cpu = true
	ai_difficulty = d
	if(CALC._randint() % 10 > 7):
		ai_defense_coeff = 2
	if(CALC._randint() % 10 > 7):
		ai_offense_coeff = 2
	if(CALC._randint() % 10 > 7):
		ai_economy_coeff = 2
	ai_ship_d_threshold = 30 + 30 * CALC._randint()

func _setup_factory(s,obj):
	for i in range(obj.modules.size()):
		if(obj.modules[i].name == "Hangar_Factory"):
			obj.modules[i].ship_id = item_bag[s]

func _setup_base():
	var mode = 0
	var location
	var d = 0
	if(variant == 1):
		mode = 1
	if(LEVELS.level_mission == "DEFENSE"):
		mode = 2
	_find_stuff()
	match mode:
		0: #Standard
			d = int(ai_difficulty)
			for i in d:
				location = _do_ai_turret_spot("CENTER")
				if(i < 5):
					_build_struct([id,1,ai_turret_a,location.x,location.y],false)
				else:
					_build_struct([id,1,ai_turret_b,location.x,location.y],false)
				if(i > 3 && i % 2 == 0):
					location = _do_ai_turret_spot("CENTER")
					_build_struct([id,1,ai_defense,location.x,location.y],false)
		1: #Boss
			energy = energy + 300
			ai_difficulty = ai_difficulty + .1
			d = int(2 * ai_difficulty + 3)
			#location = _do_ai_turret_spot("CENTER")
			#_build_struct([id,1,ai_ship_b,location.x,location.y],false)
			for i in d:
				location = _do_ai_turret_spot("CENTER")
				if(i < 5):
					_build_struct([id,1,ai_turret_a,location.x,location.y],false)
				else:
					_build_struct([id,1,ai_turret_b,location.x,location.y],false)
				if(i > 3 && i % 2 == 0):
					location = _do_ai_turret_spot("CENTER")
					_build_struct([id,1,ai_defense,location.x,location.y],false)
			for i:int in 15 + ai_difficulty:
				location = _do_ai_turret_spot("PERIMETER")
				if(i < 10):
					_build_struct([id,1,ai_turret_a,location.x,location.y],false)
				else:
					_build_struct([id,1,ai_turret_b,location.x,location.y],false)
				if(i > 3 && i % 2 == 0):
					location = _do_ai_turret_spot("PERIMETER")
					_build_struct([id,1,ai_defense,location.x,location.y],false)
		2: #Defense
			pass

func _setup_station():
	print("Setup Station")
	print(id)
	#print(LEVELS.spots[id - 1])
	#TODO ERROR HERE
	if(id - 1 < LEVELS.spots.size()):
		_build_struct([id,1,ai_base,LEVELS.spots[id - 1].x,LEVELS.spots[id - 1].y],true)
		_find_stuff()

func _setup_resources(s):
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
