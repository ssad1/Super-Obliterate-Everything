extends Node2D

@onready var Map_Black_Hole = preload("res://Terminal/Map/Map_Black_Hole.tscn")
@onready var Map_White_Dwarf = preload("res://Terminal/Map/Map_White_Dwarf.tscn")
@onready var Map_Star_O = preload("res://Terminal/Map/Map_Star_O.tscn")
@onready var Map_Star_B = preload("res://Terminal/Map/Map_Star_B.tscn")
@onready var Map_Star_A = preload("res://Terminal/Map/Map_Star_A.tscn")
@onready var Map_Star_F = preload("res://Terminal/Map/Map_Star_F.tscn")
@onready var Map_Star_G = preload("res://Terminal/Map/Map_Star_G.tscn")
@onready var Map_Star_K = preload("res://Terminal/Map/Map_Star_K.tscn")
@onready var Map_Star_M = preload("res://Terminal/Map/Map_Star_M.tscn")
@onready var Map_Asteroid = preload("res://Terminal/Map/Map_Asteroid.tscn")
@onready var Map_Planet = preload("res://Terminal/Map/Map_Planet.tscn")
@onready var Map_Trail = preload("res://Terminal/Map/Map_Trail.tscn")
@onready var Map_Mission = preload("res://Terminal/Map/Map_Mission.tscn")
@onready var Map_Mission_Lines = preload("res://Terminal/Map/Map_Mission_Line.tscn")
@onready var center = Vector2(0,0)

var star
var asteroids = []
var planets = []
var planet_trails = []
var missions = []
var mission_lines = []
var zoom = .01
var speed = 0
var phase = 0
var starr = 0
var star_heat = 0

func _ready():
	EVENTS.connect("button_generate_pressed", Callable(self, "_generate_map"))
	EVENTS.connect("zoom_map", Callable(self, "_zoom_map"))
	EVENTS.connect("submenu_button_press", Callable(self, "_submenu_button_press"))
	set_position(Vector2(GLOBAL.resx / 2, GLOBAL.resy / 2 + 50))
	SPAWNER.solarsystem = self
	_generate_map()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(zoom < 1):
		zoom = zoom + 5 * delta
		if(zoom > 1):
			zoom = 1
		set_scale(Vector2(zoom,zoom))
	if(speed > 0):
		speed = speed - 5 * delta
		if(speed < 0):
			speed = 0
			_generate_missions()
	phase = phase + 100 * delta * speed

func _clear_map():
	var i
	if(star != null):
		star.queue_free()
	
	i = asteroids.size() - 1
	while i > -1:
		asteroids[i].queue_free()
		asteroids.remove_at(i)
		i = i - 1
	
	i = planets.size() - 1
	while i > -1:
		planets[i].queue_free()
		planets.remove_at(i)
		i = i - 1
	
	i = planet_trails.size() - 1
	while i > -1:
		planet_trails[i].queue_free()
		planet_trails.remove_at(i)
		i = i - 1
	
	i = mission_lines.size() - 1
	while i > -1:
		mission_lines[i].queue_free()
		mission_lines.remove_at(i)
		i = i - 1
	
	i = missions.size() - 1
	while i > -1:
		missions[i].queue_free()
		missions.remove_at(i)
		i = i - 1

func _clear_ui():
	var i
	i = mission_lines.size() - 1
	while i > -1:
		mission_lines[i].queue_free()
		mission_lines.remove_at(i)
		i = i - 1
	i = missions.size() - 1
	while i > -1:
		missions[i].hide()
		missions[i].queue_free()
		missions.remove_at(i)
		i = i - 1
	i = planets.size() - 1
	while i > -1:
		planets[i].selected = false
		i = i - 1

func _generate_map():
	_clear_map()
	CALC.rseed = ACCOUNT.campaign_seed
	_generate_star()
	_generate_planets()
	EVENTS.emit_signal("show_map")
	zoom = .01
	speed = 10
	phase = 0

func _generate_asteroids(r,w,dir):
	var a
	var rr
	var dense = 2 + CALC._randint() % 3
	var asteroid_num = CALC._randint() % 800 + 200
	var ringcolor = CALC._rand() * .8 + .2
	if(CALC._rand() > 0.5):
		asteroid_num = 50 + CALC._randint() % 200
	for i in range(asteroid_num):
		if(CALC._rand() > 0.5):
			rr = .5 * pow(CALC._rand(),dense) * w + r
		else:
			rr = -.5 * pow(CALC._rand(),dense) * w + r
		a = Map_Asteroid.instantiate()
		a.ringcolor = ringcolor
		a._ignite()
		a.dir = dir
		a._calculate_period(rr,100)
		a.set_position(Vector2(center[0],center[1] + rr))
		a.center = center
		add_child(a)
		asteroids.append(a)

func _generate_missions():
	var a
	var r
	var k
	var da = 3000
	var c = [3000]
	var done = false
	var allgood = false
	var clear_flag = false
	if(missions.size() > 0):
		_clear_ui()
	missions = []
	for i in range(planets.size()):
		a = Map_Mission.instantiate()
		a.set_position(planets[i].position + Vector2(-16,-16))
		add_child(a)
		a.id = i
		a.missions = missions
		a.planet = planets[i]
		a.star = star
		missions.append(a)
	for i in range(missions.size()):
		r = missions[i]._find_closest(0)
		if(r[0] != 3000): #Error check
			if(r[0] < da):
				c = r
				da = r[0]
	if(c[0] != 3000):
		#Connect Shortest
		c[1]._connect(c[2])
	done = false
	while(done == false):
		da = 3000
		c = [3000]
		#Connect closest unconnected node to connected node
		for i in range(missions.size()):
			if(missions[i].connected == false):
				r = missions[i]._find_closest(1)
				if(r[0] != 3000): #Error check
					if(r[0] < da):
						c = r
						da = r[0]
		if(c[0] != 3000):
			c[1]._connect(c[2])
		#Check if all connected
		allgood = true
		for i in range(missions.size()):
			if(missions[i].connected == false):
				allgood = false
		if(allgood == true):
			done = true
	#All Connected"
	da = 0
	c = [0]
	for i in range(missions.size()):
		r = missions[i]._find_farthest(0)
		if(r[0] != 0): #Error check
			if(r[0] > da):
				c = r
				da = r[0]
	if(c[0] != 0):
		c[1]._become_start()
		c[2]._become_boss()
	for i in range(missions.size()):
		for j in range(missions[i].connections.size()):
			a = Map_Mission_Lines.instantiate()
			a._draw_line(missions[i],missions[i].connections[j])
			a.set_position(Vector2(0,0))
			add_child(a)
			mission_lines.append(a)
	#Clear Duplicate Lines
	k = mission_lines.size() -1
	while(k > -1):
		clear_flag = false
		for j in range(mission_lines.size()):
			if(k != j && mission_lines[k].connects[0] == mission_lines[j].connects[1] && mission_lines[k].connects[1] == mission_lines[j].connects[0]):
				clear_flag = true
		if(clear_flag == true):
			mission_lines[k].queue_free()
			mission_lines.remove_at(k)
		k = k - 1
	#Generate Mission Data
	for i in range(missions.size()):
		missions[i]._ignite(i)
	c[1]._difficulty(ACCOUNT.campaign_danger)
	ACCOUNT._gen_mission_results(missions)
	for i in range(missions.size()):
		missions[i]._set_lock()
	for i in range(mission_lines.size()):
		mission_lines[i]._set_lock()

func _generate_planets():
	var r
	var w
	var p
	var l
	var dir = 1
	r = 35 + starr
	if(CALC._rand() > 0.5):
		dir = 1
	else:
		dir = -1
	while(r < 400):
		if(CALC._rand() > 0.15):
			p = Map_Planet.instantiate()
			l = Map_Trail.instantiate()
			p._ready()
			p._ignite()
			p.star_heat = star_heat
			w = (2 + CALC._rand() * 2) * p.radius
			p._calculate_period(r + .5 * w,100)
			p.center = center
			p.dir = dir
			l.dir = dir
			p.set_position(Vector2(center[0],center[1] + r + .5 * w))
			l._draw_line(r + .5 * w, p.period)
			l.phaseshift = p.phaseshift
			l.set_position(Vector2(center[0],center[1]))
			l.width = int(p.radius / 5 + 1)
			add_child(l)
			planet_trails.append(l)
			add_child(p)
			planets.append(p)
			r = r + w
		elif(CALC._rand() > 0.25):
			w = CALC._rand() * 20 + 10
			_generate_asteroids(r + .5 * w, w, dir)
			r = r + w
		else:
			w = CALC._randint() % 30 + 5
			r = r + w
			dir = dir * -1

func _generate_star():
	var startype = CALC._randint() % 7
	starr = 0
	LEVELS.startype = startype
	match(startype):
		0:
			star = Map_Star_M.instantiate()
			starr = 0
			star_heat = 55
		1: 
			star = Map_Star_K.instantiate()
			starr = 3
			star_heat = 57
		2: 
			star = Map_Star_G.instantiate()
			starr = 6
			star_heat = 60
		3: 
			star = Map_Star_F.instantiate()
			starr = 9
			star_heat = 65
		4: 
			star = Map_Star_A.instantiate()
			starr = 14
			star_heat = 70
		5: 
			star = Map_Star_B.instantiate()
			starr = 30
			star_heat = 80
		6: 
			star = Map_Star_O.instantiate()
			starr = 40
			star_heat = 90
		7: 
			star = Map_White_Dwarf.instantiate()
			starr = 30
			star_heat = 35
		9: 
			star = Map_Black_Hole.instantiate()
			starr = 20
			star_heat = 0
	
	star.set_position(center)
	add_child(star)

func _zoom_map():
	zoom = .01
	speed = 10
	phase = 0
	_clear_ui()
	#EVENTS.emit_signal("fadeset",75)
	show()

func _submenu_button_press(n):
	if(n == "Button_Conquest"):
		_zoom_map()
	else:
		hide()
