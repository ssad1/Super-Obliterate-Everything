extends TextureButton

var connected = false
var connections = []
var missions = []
var id = 0
var farthest_id = -1
var distance_to_start = -1
var planet
var star

var mission_data = []
var mission_seed = 0
var is_start = false
var v = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#Uncomment to make missions be available at any given time
func _process(delta):
	show()

func _ignite(s):
	var d
	var t
	CALC.rseed = ACCOUNT.campaign_seed + 1000 * s
	mission_seed = CALC._randint()
	for i in range(s):
		mission_seed = CALC._randint()
	mission_data = LEVELS._design_mission(mission_seed, ACCOUNT.campaign_id, v)
	d = planet.orbitr
	mission_data[4] = planet.temp
	mission_data[6] = star.s
	mission_data[8] = planet.planet_type
	mission_data[9] = planet.asteroids

func _pressed():
	SFX._play_new([2001])
	LEVELS.mission_id = id
	LEVELS.level_seed = mission_seed
	LEVELS.level_mission = mission_data[0]
	LEVELS.level_players = mission_data[1]
	LEVELS.level_map = mission_data[2]
	LEVELS.level_size = mission_data[3]
	LEVELS.level_temperature = mission_data[4]
	LEVELS.mission_difficulty = mission_data[5]
	LEVELS.level_star = mission_data[6]
	LEVELS.level_resources = mission_data[7]
	LEVELS.level_planet = mission_data[8]
	LEVELS.level_asteroids = mission_data[9]
	GLOBAL.nextscreen = 2
	EVENTS.emit_signal("flipin")
	SPAWNER._spawn([SPAWNER.spawn_objs.EFFECT_CLICK_BOOM],null,Vector2(position.x + 16,position.y + 16),Vector2(0,0),0,10,0)
	planet.selected = false
	hide()

func _mouse_entered():
	#EVENTS.emit_signal("mission_hover_in",position + get_parent().position)
	EVENTS.emit_signal("mission_hover_in",self)
	#planet.selected = true

func _mouse_exited():
	EVENTS.emit_signal("mission_hover_out")
	#planet.selected = false


func _become_start():
	_find_farthest(1)
	is_start = true
	#show()

func _become_boss():
	#show()
	v = 1 #BOSS

func _connect(a):
	var already_connected = false
	for i in connections.size():
		if connections[i].id == a.id:
			already_connected = true
	if !already_connected:
		connected = true
		connections.append(a)
		a._connect(self)

func _difficulty(d):
	if mission_data[5] == 0:
		mission_data[5] = d
	for i in connections.size():
		if connections[i].mission_data[5] == 0:
			connections[i]._difficulty(d + .1)

func _find_closest(mode):
	var da = 3000
	var db = 3000
	var c = -1
	var result
	var testd = false
	#mode 0: distance to closest
	#mode 1: distance to closest connected
	for i in missions.size():
		testd = false
		if mode == 0 && missions[i].id != id:
			testd = true
		if mode == 1 && missions[i].id != id && missions[i].connected:
			testd = true
		if testd:
			db = position.distance_to(missions[i].position)
			if db < da:
				da = db
				c = i

	if c != -1:
		result = [da,self,missions[c]]
	else:
		result = [3000,self,self]

	return result

func _find_farthest(mode):
	var ds = []
	var da = 0
	var db = 0
	var c = -1
	var result
	#mode 0: just calculate
	#mode 1: assign distance to missions
	for i in missions.size():
		if missions[i].id == id:
			ds.append(0)
		else:
			ds.append(-1)
	
	#Flood Fill
	for k in ds.size():
		for i in ds.size():
			if ds[i] == -1:
				da = 1000
				for j in missions[i].connections.size():
					db = -1
					if ds[missions[i].connections[j].id] != -1:
						db = ds[missions[i].connections[j].id]
						if db < da:
							da = db
				if da != 1000:
					ds[i] = da + 1
	da = 0
	for i in ds.size():
		if ds[i] > da:
			da = ds[i]
			c = i

	if da != 0:
		farthest_id = c

	if mode == 1:
		for i in ds.size():
			missions[i].distance_to_start = ds[i]

	if c != -1:
		result = [da,self,missions[c]]
	else:
		result = [0,self,self]

	return result

func _set_lock():
	var locked = true
	for i in connections.size():
		if  ACCOUNT.mission_results[connections[i].id] == 1:
			locked = false
	if ACCOUNT.mission_results[id] == 0 && is_start:
		locked = false
	if ACCOUNT.mission_results[id] == 1:
		locked = true
	if locked:
		hide()
		planet.selected = false
	else:
		show()
		planet.selected = true
