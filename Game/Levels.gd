extends Node

var grid = []
var spots = []
var spot_theta = 0
var player_list = [2,3,4,5,6]
var startype = 0
var event_list = []

var victory_clock = -1
var mission_id = 0
var mission_difficulty = 0
var level_seed = 0
var level_size
var level_players
var level_map
var level_mission
var level_temperature
var level_star
var level_resources
var level_planet
var level_asteroids

var base_radius = .32

var small_rock = 112
var big_rock = 113

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func _add_start_spots():
	for i in range(spots.size()):
		grid[spots[i].x][spots[i].y] = i + 1

func _big_rocks():
	var rockcount = 0
	for xx in range(grid.size() - 2):
		for yy in range(grid[xx].size() - 2):
			rockcount = 0
			for xxx in range(2):
				for yyy in range(2):
					if(grid[xx + xxx][yy + yyy] == small_rock):
						rockcount = rockcount + 1
					if(grid[xx + xxx][yy + yyy] == -1):
						rockcount = -4
			if(rockcount >= 3):
				grid[xx][yy] = big_rock
				grid[xx + 1][yy] = -1
				grid[xx][yy + 1] = -1
				grid[xx + 1][yy + 1] = -1
			if(rockcount == 2):
				if(grid[xx][yy] == small_rock && grid[xx + 1][yy] == small_rock && grid[xx + 2][yy] == small_rock):
					grid[xx][yy] = big_rock
					grid[xx + 1][yy] = -1
					grid[xx][yy + 1] = -1
					grid[xx + 1][yy + 1] = -1
					grid[xx + 2][yy] = 0
				if(grid[xx][yy] == small_rock && grid[xx][yy + 1] == small_rock && grid[xx][yy + 2] == small_rock):
					grid[xx][yy] = big_rock
					grid[xx][yy + 1] = -1
					grid[xx + 1][yy] = -1
					grid[xx + 1][yy + 1] = -1
					grid[xx][yy + 2] = 0
					
	
func _convert_polar_to_grid(r, theta):
	var spot = Vector2(0,0)
	spot = r * Vector2.from_angle(theta)
	spot.x = floor(spot.x + .5 * grid.size())
	spot.y = floor(spot.y + .5 * grid.size())
	return spot

func _convert_grid_to_polar(spot):
	var size = 0.5 * grid.size()
	
	var dx = spot.x - size
	var dy = spot.y - size
	
	var r = Vector2(dx, dy).length()      # distância ao centro
	var theta = atan2(dy, dx)             # ângulo em radianos
	
	return Vector2(r, theta)

func _design_level():
	var players = level_players
	var spot
	var v = 0
	randomize()
	CALC.rseed = level_seed
	base_radius = .32
	victory_clock = -1
	_setup_grid(_select_grid_size(level_size))
	print("Level Players: ")
	print(players)
	_setup_players(players)
	_set_asteroids()
	match level_map:
		"SOLO ARCS":
			_start_spots_solo()
			_rock_arc(small_rock,spots[0], 10, 2 * PI * CALC._rand(), PI / 2, 2)
			_rock_arc(small_rock,spots[0], 16, 2 * PI * CALC._rand(), PI / 3, 2)
			_rock_arc(small_rock,spots[0], 22, 2 * PI * CALC._rand(), PI / 4, 2)
			_rock_arc(small_rock,spots[0], 28, 2 * PI * CALC._rand(), PI / 5, 2)
			_rock_random(round(.5 * grid.size()))
		"SOLO RING":
			_start_spots_solo()
			_rock_start(2)
			_rock_random(round(.5 * grid.size()))
		"SOLO SPARSE FIELD":
			_start_spots_solo()
			_rock_random(round(.5 * grid.size()))
		"SOLO DENSE FIELD":
			_start_spots_solo()
			_rock_random(round(1 * grid.size()))
			_rock_random_large(round(2 * grid.size()))
		"SOLO DIFFUSE FIELD":
			_start_spots_solo()
			_rock_random(round(1 * grid.size()))
		"SOLO CRESCENT":
			_start_spots_solo()
			_rock_start(0)
			_rock_arc(small_rock,spots[0], round(grid.size() * base_radius * 2 / (players.size() - 1)), 2 * PI * CALC._rand(), PI, 2)
			_rock_random(round(.5 * grid.size()))
		"SOLO SPIRAL":
			_start_spots_solo()
			for j in range(round(.35 * grid.size())):
				spot = _convert_polar_to_grid(j  * grid.size() / 64 + 8,_convert_grid_to_polar(spots[0]).y + j * .1 * (PI / 2))
				_rock_blob(small_rock,spot,4,3)
				spot = _convert_polar_to_grid(j  * grid.size() / 64 + 8,_convert_grid_to_polar(spots[0]).y + j * .1 * (PI / 2) + PI)
				_rock_blob(small_rock,spot,4,3)
			_rock_random(round(.5 * grid.size()))
		"SOLO CLUMPS":
			_start_spots_solo()
			for j in range(4):
				spot = Vector2(round(CALC._rand() * grid.size()),round(CALC._rand() * grid.size()))
				_rock_blob(small_rock,spot,16,9)
			_rock_random(round(.5 * grid.size()))
		"SPARSE FIELD":
			_start_spots(players.size() - 1)
			_rock_random(round(.5 * grid.size()))
		"DENSE FIELD":
			_start_spots(players.size() - 1)
			_rock_random(round(1 * grid.size()))
			_rock_random_large(round(2 * grid.size()))
		"DIFFUSE FIELD":
			_start_spots(players.size() - 1)
			#_rock_start(0)
			#_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			_rock_random(round(1 * grid.size()))
		"RINGS":
			_start_spots(players.size() - 1)
			_rock_start(2)
			_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			_rock_random(round(.5 * grid.size()))
		"KING OF THE HILL":
			_start_spots(players.size() - 1)
			spot = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
			_rock_arc(small_rock,spot, 2, 2 * PI * CALC._rand(), 2 * PI, 3)
			_rock_arc(small_rock,spot, 5, 2 * PI * CALC._rand(), 2 * PI, 3)
			_rock_arc(small_rock,spot, 7, 2 * PI * CALC._rand(), 2 * PI, 3)
			_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			_rock_random(round(.5 * grid.size()))
		"PETALS":
			_start_spots(players.size() - 1)
			spot = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
			_rock_start(0)
			_rock_expansion(2)
			_rock_arc(small_rock,spot, 9, 2 * PI * CALC._rand(), 2 * PI, 3)
			_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			_rock_random(round(.5 * grid.size()))
		"DONUT":
			_start_spots(players.size() - 1)
			spot = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
			_rock_arc(small_rock,spot, grid.size() * .25, 2 * PI * CALC._rand(), 2 * PI, 8)
			_rock_random(round(.5 * grid.size()))
		"DOUBLE DONUT":
			_start_spots(players.size() - 1)
			spot = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
			_rock_arc(small_rock,spot, grid.size() * (base_radius - .07), 2 * PI * CALC._rand(), 2 * PI, 5)
			_rock_arc(small_rock,spot, grid.size() * (base_radius + .07), 2 * PI * CALC._rand(), 2 * PI, 5)
			_rock_random(round(.5 * grid.size()))
		"INNER DONUT":
			_start_spots(players.size() - 1)
			spot = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
			_rock_start(0)
			_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			_rock_arc(small_rock,spot, grid.size() * .15, 2 * PI * CALC._rand(), 2 * PI, 6)
			_rock_random(round(.5 * grid.size()))
		"BULLSEYE":
			_start_spots(players.size() - 1)
			spot = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
			_rock_arc(small_rock,spot, grid.size() * .22, 2 * PI * CALC._rand(), 2 * PI, 2)
			spot = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
			_rock_arc(small_rock,spot, 3, 2 * PI * CALC._rand(), 2 * PI, 3)
			_rock_arc(small_rock,spot, 2, 2 * PI * CALC._rand(), 2 * PI, 3)
			_rock_random(round(.5 * grid.size()))
		"SUNFLOWER":
			_start_spots(players.size() - 1)
			spot = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
			_rock_start(3)
			_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			_rock_arc(small_rock,spot, round(grid.size() * (base_radius - .125)), 2 * PI * CALC._rand(), 2 * PI, 5)
		"CRESCENTS":
			_start_spots(players.size() - 1)
			_rock_start(0)
			#_rock_arc(small_rock,spots[0], round(base_radius * 2 / (players.size() - 1)), 2 * PI * CALC._rand(), 2 * PI, 3)
			_rock_arc(small_rock,spots[0], round(grid.size() * base_radius * 2 / (players.size() - 1)), 2 * PI * CALC._rand(), PI, 2)
			_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			_rock_random(round(.5 * grid.size()))
		"ARCS":
			_start_spots(players.size() - 1)
			_rock_arc(small_rock,spots[0], 10, 2 * PI * CALC._rand(), PI / 2, 2)
			_rock_arc(small_rock,spots[0], 16, 2 * PI * CALC._rand(), PI / 3, 2)
			_rock_arc(small_rock,spots[0], 22, 2 * PI * CALC._rand(), PI / 4, 2)
			_rock_arc(small_rock,spots[0], 28, 2 * PI * CALC._rand(), PI / 5, 2)
			_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			_rock_random(round(.5 * grid.size()))
		"BORDERS":
			_start_spots(players.size() - 1)
			_rock_start(0)
			_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			spot = Vector2(0,0)
			for i in range(spots.size()):
				_rock_polar_line(small_rock,spot,round(.15 * grid.size()),round(.4 * grid.size()),_convert_grid_to_polar(spots[0]).y + (i + .5) * (2 * PI) / spots.size(),2)
				_rock_polar_line(small_rock,spot,round(.15 * grid.size()),round(.4 * grid.size()),_convert_grid_to_polar(spots[0]).y + (i + .5) * (2 * PI) / spots.size(),8)
			_rock_random(round(.5 * grid.size()))
		"SPIRAL":
			_start_spots(players.size() - 1)
			for i in range(players.size() - 1):
				for j in range(round(.35 * grid.size())):
					spot = _convert_polar_to_grid(j  * grid.size() / 64 + 8,_convert_grid_to_polar(spots[i]).y + j * .1 * (PI / 2))
					_rock_blob(small_rock,spot,4,3)
			_rock_random(round(.5 * grid.size()))
		"CLUMPS":
			_start_spots(players.size() - 1)
			for j in range(2):
				spot = Vector2(spots[0].x + round((CALC._rand() - 0.5) * grid.size() / (players.size())),spots[0].y + round((CALC._rand() - 0.5) * grid.size() / (players.size())))
				_rock_blob(small_rock,spot,16,9)
			for j in range(4):
				spot = Vector2(round(.5 * grid.size()) + round((CALC._rand() - 0.5) * grid.size() * 0.5),round(.5 * grid.size()) + round((CALC._rand() - 0.5) * grid.size() * 0.5))
				_rock_blob(small_rock,spot,16,12)
			_mirror_rotate(_convert_grid_to_polar(spots[0]).y,spots.size())
			spot = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
			_rock_blob(small_rock,spot,16,9)
			_rock_random(round(.5 * grid.size()))
	_add_start_spots()
	_big_rocks()
	_gen_level()
	_set_lights()
	_gen_events()

func _design_mission(s, id, v):
	var mission_data = []
	var skirmish_maps = ["SPARSE FIELD", "DENSE FIELD", "DIFFUSE FIELD", "RINGS", "KING OF THE HILL", "PETALS", "DONUT", "DOUBLE DONUT", "INNER DONUT", "BULLSEYE", "SUNFLOWER", "CRESCENTS", "ARCS", "BORDERS", "SPIRAL", "CLUMPS"]
	var skirmish_resources = ["STANDARD","STOCKPILE","HIGH ENERGY","HEAVY METAL","MIXED START"]
	var map_list = []
	var resource_list = []
	var mission = ""
	var players = [0,1]
	var map = ""
	var reward = 0
	var player_num = 0
	var dice = 0
	var size = "SMALL"
	var resources = ""
	#[mission_type, player_array, map, size, temperature, reward, difficulty, hazard, environment, star, resources, planet, asteroids]
	map = "STANDARD"
	CALC.rseed = s
	dice = _zone_levels(id)
	if(v == 1): #Become Boss Level
		dice = 5
	_zone_factions(id)
	match dice:
		0:#Duel
			mission = "DUEL"
			player_num = 2
			map_list = skirmish_maps
			resource_list = skirmish_resources
		1:#Defense
			mission = "DEFENSE"
			player_num = 2
			map_list = ["SOLO ARCS", "SOLO RING", "SOLO SPARSE FIELD", "SOLO DENSE FIELD", "SOLO DIFFUSE FIELD", "SOLO CRESCENT", "SOLO SPIRAL", "SOLO CLUMPS"]
			resource_list = ["STANDARD"]
		2:#Skirmish
			mission = "SKIRMISH"
			player_num = 3# + CALC._randint() % 2
			map_list = skirmish_maps
			resource_list = skirmish_resources
		3:#Flank
			mission = "FLANK"
			player_num = 3
			
			resource_list = skirmish_resources
		4:#Pincer
			mission = "PINCER"
			player_num = 3
			
			resource_list = skirmish_resources
		5:#BOSS
			mission = "BOSS"
			player_num = 2
			map_list = skirmish_maps
			resource_list = ["HIGH ENERGY"]
		6:#Greed
			mission = "GREED"
			player_num = 2
		7:#Capture
			mission = "CAPTURE"
			player_num = 2 + CALC._randint() % 2
		8:#Control
			mission = "CONTROL"
			player_num = 2 + CALC._randint() % 2
		9:#Blockade
			mission = "BLOCKADE"
			player_num = 2
		10:#Rescue
			mission = "RESCUE"
			player_num = 2
		11:#Siege
			mission = "SIEGE"
			player_num = 2
		12:#Colonists
			mission = "COLONISTS"
			player_num = 2
		13:#Intercept
			mission = "INTERCEPT"
			player_num = 2
		14:#Fleets
			mission = "FLEETS"
			player_num = 2
		15:#Surround
			mission = "SURROUND"
			player_num = 4
		16:#Allies
			mission = "ALLIES"
			player_num = 4
		17:#Raid
			mission = "RAID"
			player_num = 2
		
	players = [0,1] + _pick_players(player_num - 1)
	dice = CALC._randint() % map_list.size()
	map = map_list[dice]
	size = _select_size(players.size())
	dice = CALC._randint() % resource_list.size()
	resources = resource_list[dice]
	
	mission_data.append(mission)
	mission_data.append(players)
	mission_data.append(map)
	mission_data.append(size)
	mission_data.append(0)
	mission_data.append(0)
	mission_data.append(0)
	mission_data.append(resources)
	mission_data.append(0)
	mission_data.append(0)
	
	return mission_data

func _zone_factions(z_id):
	match z_id:
		0:
			player_list = [2,3,4,5,6]
		1:
			player_list = [5,6]
		2:
			player_list = [3,4]

func _zone_levels(z_id):
	var dice_list = []
	var d = 0
	var d_id = 0
	match int(z_id):
		0:
			dice_list = [0,0,1,2]
		1:
			dice_list = [0]
		2:
			dice_list = [0]
	d_id = CALC._randint() % dice_list.size()
	d = dice_list[d_id]
	return d

func _gen_events():
	var event = []
	event_list = []
	var wave_start = 0
	var wave_length = 0
	var wave_gap = 0
	#Type, Start Time, End Time, Clock, Max Clock, Spawn Player, Spawn ID, Spawn Number, Spawn Direction
	match(level_mission):
		"DEFENSE":
			wave_start = 800 - round(mission_difficulty * 5)
			wave_length = 50 + round(mission_difficulty * 10)
			wave_gap = 600 - round(mission_difficulty * 5)
			if(wave_start < 400):
				wave_start = 400
			if(wave_gap < 300):
				wave_gap = 300
				
			event = [1,wave_start,wave_start + wave_length,0,7,2,1,1,0]
			event_list.append(event)
			if(mission_difficulty > 5):
				event = [1,wave_start, wave_start + wave_length,0,30,2,2,1,0]
				event_list.append(event)
			
			wave_length = wave_length + 25 + round(mission_difficulty * 10)
			wave_start = wave_start + wave_length + wave_gap
			event = [1,wave_start, wave_start + wave_length,0,7,2,1,1,0]
			event_list.append(event)
			event = [1,wave_start, wave_start + wave_length,0,20,2,2,1,0]
			event_list.append(event)
			if(mission_difficulty > 5):
				event = [1,wave_start, wave_start + wave_length,0,40,2,3,1,0]
				event_list.append(event)
			
			if(mission_difficulty > 2):
				wave_length = wave_length + 25 + round(mission_difficulty * 10)
				wave_start = wave_start + wave_length + wave_gap
				event = [1,wave_start, wave_start + wave_length,0,10,2,1,1,0]
				event_list.append(event)
				event = [1,wave_start, wave_start + wave_length,0,20,2,2,1,0]
				event_list.append(event)
				event = [1,wave_start, wave_start + wave_length,0,30,2,3,1,0]
				event_list.append(event)
				event = [1,wave_start, wave_start + wave_length,0,60,2,4,1,0]
				event_list.append(event)
			victory_clock = wave_start + wave_length

func _gen_level():
	SPAWNER.game.mapsize = Vector2(grid.size() * 32, grid[0].size() * 32)
	for xx in range(grid.size()):
		for yy in range(grid[xx].size()):
			#if(grid[xx][yy] > 0 && grid[xx][yy] < 10): #Station now handled in Player
				#SPAWNER._spawn([200],grid[xx][yy],Vector2(xx * 32, yy * 32),Vector2(0,0),0,0,0)
			if(grid[xx][yy] == small_rock):
				SPAWNER._spawn([small_rock],0,Vector2(xx * 32, yy * 32),Vector2(0,0),0,0,0)
			if(grid[xx][yy] == big_rock):
				SPAWNER._spawn([big_rock],0,Vector2(xx * 32, yy * 32),Vector2(0,0),0,0,0)

func _on_grid(spot):
	var good = true
	if(spot.x < 0):
		good = false
	if(spot.x >= grid.size()):
		good = false
	if(spot.y < 0):
		good = false
	if(spot.y >= grid.size()):
		good = false
	return good

func _pick_players(num):
	var plist = []
	var pick
	var add_player = true
	while add_player == true:
		pick = CALC._randint() % player_list.size()
		for i in range(plist.size()):
			if(player_list[pick] == plist[i]):
				add_player = false
		if(add_player == true):
			plist.append(player_list[pick])
		add_player = true
		if(plist.size() >= num):
			add_player = false
		#if(plist.size() >= player_list.size()):
		#	add_player = false
	return plist

func _mirror_rotate(theta, total_splits):
	var i = 0
	var test_theta = 0
	var coord = Vector2(0,0)
	var new_coord = Vector2(0,0)
	var polar_coord = Vector2(0,0)
	var current_split = 0
	var split_arc = 2 * PI / total_splits
	
	for xx in range(grid.size()):
		for yy in range(grid.size()):
			coord = Vector2(xx,yy)
			polar_coord = _convert_grid_to_polar(coord)
			test_theta = polar_coord.y
			current_split = 0
			while(CALC._radian_distance(test_theta,theta) > .5 * split_arc):
				test_theta = float(test_theta) - split_arc
				test_theta = CALC._clamp_radians(test_theta)
				current_split = current_split + 1
			polar_coord.y = CALC._clamp_radians(polar_coord.y - current_split * split_arc)
			new_coord = _convert_polar_to_grid(polar_coord.x, polar_coord.y)
			if(_on_grid(new_coord) == true):
				grid[xx][yy] = grid[new_coord.x][new_coord.y]

func _mirror_rotate_coord(r, theta, split, total_splits, direction):
	var spot = Vector2(0,0)
	theta = theta + direction * (float(split) / float(total_splits)) * 2 * PI
	spot = _convert_polar_to_grid(r, theta)
	return spot

func _rock_arc(s, center, r, theta, arc_length, diffuse):
	var spot = Vector2(0,0)
	var scale = r
	for i in range(scale * arc_length):
		spot.x = center.x + r * cos(theta - .5 * arc_length + float(i) / float(scale))
		spot.y = center.y - r * sin(theta - .5 * arc_length + float(i) / float(scale))
		spot.x = spot.x - .5 * diffuse + CALC._rand() * diffuse
		spot.y = spot.y - .5 * diffuse + CALC._rand() * diffuse
		if(_on_grid(Vector2(floor(spot.x),floor(spot.y))) == true):
			grid[floor(spot.x)][floor(spot.y)] = s

func _rock_blob(s, center, num, diffuse):
	var spot = Vector2(0,0)
	for i in range(num):
		spot.x = center.x - .5 * diffuse + CALC._rand() * diffuse
		spot.y = center.y - .5 * diffuse + CALC._rand() * diffuse
		if(_on_grid(Vector2(floor(spot.x),floor(spot.y))) == true):
			grid[floor(spot.x)][floor(spot.y)] = s

func _rock_expansion(s):
	var i
	var polar
	var newpolar
	var coord
	var theta
	var max_arc = (2 * PI / spots.size()) * .8
	
	match s:
		0:
			coord = spots[0]
			polar = _convert_grid_to_polar(coord)
			polar.x = polar.x / 2
			polar.y = polar.y - .6 * max_arc + CALC._rand() * max_arc
			coord = _convert_polar_to_grid(polar.x, polar.y)
			_rock_arc(small_rock, coord, 6, 2 * PI * CALC._rand(), PI / 2, 2)
		1:
			coord = spots[0]
			polar = _convert_grid_to_polar(coord)
			polar.x = polar.x / 2
			polar.y = polar.y - .6 * max_arc + CALC._rand() * max_arc
			coord = _convert_polar_to_grid(polar.x, polar.y)
			_rock_arc(small_rock, coord, 6, 2 * PI * CALC._rand(), PI / 2, 2)
			_rock_arc(small_rock, coord, 10, 2 * PI * CALC._rand(), PI / 2, 4)
		2:
			coord = spots[0]
			polar = _convert_grid_to_polar(coord)
			polar.x = polar.x / 2
			polar.y = polar.y - .6 * max_arc + CALC._rand() * max_arc
			coord = _convert_polar_to_grid(polar.x, polar.y)
			_rock_arc(small_rock, coord, 8, 2 * PI * CALC._rand(), 2 * PI, 2)
		3:	#Solo Sparse Field
			coord = spots[0]
			theta = CALC._rand() * 2 * PI
			coord = Vector2(spots[0].x + 14 * cos(theta), spots[0].y - 14 * sin(theta))
			_rock_arc(small_rock, coord, 6, 2 * PI * CALC._rand(), PI / 2, 2)
		4:	#Solo Dense Field
			coord = spots[0]
			theta = CALC._rand() * 2 * PI
			coord = Vector2(spots[0].x + 14 * cos(theta), spots[0].y - 14 * sin(theta))
			_rock_arc(small_rock, coord, 6, 2 * PI * CALC._rand(), PI / 2, 2)
			_rock_arc(small_rock, coord, 10, 2 * PI * CALC._rand(), PI / 2, 4)
	
func _rock_polar_line(s, center, ra, rb, theta, diffuse):
	var spot = Vector2(0,0)
	for i in range(rb - ra):
		spot = _convert_polar_to_grid(i+ra, theta)
		spot.x = spot.x - .5 * diffuse + CALC._rand() * diffuse
		spot.y = spot.y - .5 * diffuse + CALC._rand() * diffuse
		if(_on_grid(Vector2(floor(spot.x),floor(spot.y))) == true):
			grid[floor(spot.x)][floor(spot.y)] = s

func _rock_random(num_rocks):
	for i in range(num_rocks):
		grid[CALC._randint() % grid.size()][CALC._randint() % grid.size()] = small_rock

func _rock_random_large(num_rocks):
	var xx = 0
	var yy = 0
	for i in range(num_rocks):
		xx = CALC._randint() % (grid.size() - 1)
		yy = CALC._randint() % (grid.size() - 1)
		grid[xx][yy] = small_rock
		grid[xx + 1][yy] = small_rock
		grid[xx][yy + 1] = small_rock
		grid[xx + 1][yy + 1] = small_rock

func _rock_start(s):
	#var i = 0
	match s:
		0:
			_rock_arc(small_rock,spots[0], 12, 2 * PI * CALC._rand(), PI / 2, 2)
		1:
			_rock_arc(small_rock,spots[0], 10, 2 * PI * CALC._rand(), PI, 2)
			_rock_arc(small_rock,spots[0], 14, 2 * PI * CALC._rand(), PI / 3, 3)
		2:
			_rock_arc(small_rock,spots[0], 16, 2 * PI * CALC._rand(), 2 * PI, 3)
		3: 
			_rock_arc(small_rock,spots[0], round(.125 * grid.size()), 2 * PI * CALC._rand(), 2 * PI, 3)

func _set_asteroids():
	match level_asteroids:
		"ICY":
			small_rock = 102
			big_rock = 103
		"LAVA":
			small_rock = 104
			big_rock = 105
		"METALLIC":
			small_rock = 106
			big_rock = 107
		"STONY":
			small_rock = 108
			big_rock = 109
		"CHONDRITE":
			small_rock = 110
			big_rock = 111
		"ROCKY":
			small_rock = 112
			big_rock = 113

func _select_size(playernum):
	var map_size = 0
	var size = "TINY"
	playernum = playernum - 1
	if(playernum < 7):
		map_size = 3
	if(playernum < 5):
		map_size = 2
	if(playernum < 4):
		map_size = 1
	if(playernum < 3):
		map_size = 0
	#if(CALC._rand() > 0.5 && map_size > 0):
	#	map_size = map_size - 1
	match map_size:
		0:
			size = "TINY"
		1:
			size = "SMALL"
		2:
			size = "MEDIUM"
		3:
			size = "LARGE"
		4:
			size = "GIANT"
	return size

func _select_grid_size(map_size):
	var size = Vector2(64,64)
	match map_size:
		"TINY":
			size = Vector2(64,64)
		"SMALL":
			size = Vector2(72,72)
		"MEDIUM":
			size = Vector2(80,80)
		"LARGE":
			size = Vector2(88,88)
		"GIANT":
			size = Vector2(96,96)
	return size

#TODO: fazer com que as cores sejam respectivas as cores das estrelas

func _set_lights():
	var light = Color(1,1,1,1)
	var fade = 255
	var bright = 1
	var s = 0
	var a = 0
	var d = 0
	var col
	#light = Color.from_hsv(CALC._rand(),.5,1,1)
	#level_temperature = "VERY HOT"
	match level_temperature:
		"EXOTIC":
			fade = 255
			bright = 1
			s = 1
			a = 100
			light = Color(1,.2,.2,1)
			d = 0
		"VERY COLD":
			fade = 255
			bright = .7
			s = 1
			a = CALC._randint() % 2 + 40
			d = 0
			match a:
				40:
					light = Color(.35,.5,1,1)
				41:
					light = Color(.5,.2,.8,1)
				42:
					light = Color(.5,.5,.8,1)
			EVENTS.emit_signal("duston",0)
			EVENTS.emit_signal("froston")
		"COLD":
			fade = 255
			bright = .9
			s = 1
			a = CALC._randint() % 4 + 20
			d = 0
			match a:
				20:
					light = Color(.8,.7,.95,1)
				21:
					light = Color(.7,.8,1,1)
				22:
					light = Color(.8,.65,.9,1)
				23:
					light = Color(.75,.8,1,1)
		"TEMPERATE":
			light = Color(1,1,1,1)
			fade = 255
			bright = 1
			s = 1
			a = CALC._randint() % 6
			d = 0
		"HOT":
			fade = 100
			bright = 1.5
			s = 1
			a = 60 + CALC._randint() % 4
			d = 0
			match a:
				60:
					light = Color(2,.9,.8,1)
				61:
					light = Color(1.8,1.2,.8,1)
				62:
					light = Color(2,1,.8,1)
				63:
					light = Color(1.7,1.2,1,1)
		"VERY HOT":
			light = Color(1,1,1,1)
			fade = 0
			bright = 2
			s = 2
			a = 80 + level_star
			d = CALC._randint() % 4
			match a:
				80:
					light = Color(1.3,1,1.2,1)
				81:
					light = Color(1.4,1.15,1,1)
				82:
					light = Color(1.35,1.2,1,1)
				83:
					light = Color(1.35,1.25,1.2,1)
				84:
					light = Color(1.3,1.3,1.35,1)
				85:
					light = Color(1.3,1.3,2,1)
				86:
					light = Color(1,1,3,1)
		"INFERNO":
			light = Color(1,1,1,1)
			fade = 0
			bright = 3
			s = 3
			a = 80 + level_star
			d = CALC._randint() % 4
			match a:
				80:
					light = Color(1.5,.5,.6,1)#Color(1.3,1,1.2,1)
				81:
					light = Color(1.4,1.15,1,1)
				82:
					light = Color(1.35,1.2,1,1)
				83:
					light = Color(1.35,1.25,1.2,1)
				84:
					light = Color(1.3,1.3,1.35,1)
				85:
					light = Color(1.3,1.3,2,1)
				86:
					light = Color(1,1,3,1)
	EVENTS.emit_signal("lightset", light, bright)
	EVENTS.emit_signal("fadeset",fade)
	EVENTS.emit_signal("envset",s,a,d)
	EVENTS.emit_signal("starheatset",level_temperature,light)

func _setup_grid(size):
	grid = []
	print("grid " + str(size))
	for xx in range(size.x):
		grid.append([])
		grid[xx]=[]
		for yy in range(size.y):
			grid[xx].append([])
			grid[xx][yy]=0

func _setup_players(players):
	var v = 0
	match level_mission:
		"BOSS":
			v = 1
	for i in range(players.size()):
		SPAWNER._spawn_player(players[i],v)

func _start_spots(num_players):
	var theta = 0
	var r = 0
	var direction = 1
	var xx = 0
	var yy = 0
	var coord = Vector2(0,0)
	
	if(CALC._rand() > 0.5):
		direction = -1
	theta = CALC._rand() * 2 * PI
	r = grid.size() * base_radius
	spots = []
	spot_theta = theta
	for i in range(num_players):
		coord = _mirror_rotate_coord(r,theta,i,num_players,direction)
		spots.append(coord)
		grid[coord.x][coord.y] = -1
		grid[coord.x][coord.y + 1] = -1
		grid[coord.x + 1][coord.y] = -1
		grid[coord.x + 1][coord.y + 1] = -1

func _start_spots_solo():
	var coord = Vector2(round(.5 * grid.size()),round(.5 * grid.size()))
	spots = []
	spots.append(coord)
	grid[coord.x][coord.y] = -1
	grid[coord.x][coord.y + 1] = -1
	grid[coord.x + 1][coord.y] = -1
	grid[coord.x + 1][coord.y + 1] = -1
