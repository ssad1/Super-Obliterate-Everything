extends Node2D

var squares = []
var dimensions = Vector2(1,1)
var center = Vector2(0,0)
var buildability = false
var mousability = false
var buildid = 0
var build_flag = 0
var energy_cost = 0
var metal_cost = 0
var supply_cost = 0
var range_radius = 0
var shield_radius = 0
var stats
var build_alert = ""
var old_build_alert = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_color_squares()
	_check_mouse()
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) == true):
		EVENTS.emit_signal("cancel_build")
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true && build_flag == 0):
		_build()
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true):
		build_flag = 1
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == false):
		build_flag = 0
	if(stats != null):
		if(is_instance_valid(stats)):
			stats.set_position(position + center)
	if(old_build_alert != build_alert):
		EVENTS.emit_signal("build_alert", build_alert)
		old_build_alert = build_alert

func _check_mouse():
	var m = get_viewport().get_mouse_position()
	var v = Vector2(GLOBAL.resx, GLOBAL.resy)
	m = m / v
	if(m.x < .265 && m.y > .76):
		mousability = false
	else:
		mousability = true

func _clear_squares():
	for i in range(squares.size()):
		squares[i].queue_free()
	squares = []

func _ignite(id,v,price,r,sr):
	var s
	_clear_squares()
	buildid = id
	dimensions = v
	energy_cost = price[0]
	metal_cost = price[1]
	supply_cost = price[2]
	range_radius = r
	shield_radius = sr
	for i in range(v.x):
		for j in range(v.y):
			s = GLOBAL.Square.instantiate()
			add_child(s)
			s.set_position(Vector2(32 * i, 32 * j))
			squares.append(s)
	center = dimensions * 16
	if(stats == null):
		stats = SPAWNER._spawn_stats()
		stats.set_position(position + center)
		_set_stats()

func _color_squares():
	var xx = 0
	var yy = 0
	var pos := Vector2(0,0)
	var building = true
	var light_color = "FLASHING"
	build_alert = ""
	#Test Squares
	for i in range(squares.size()):
		pos = (squares[i].position + self.position) / 32
		if(int(pos.x) >= 0 && int(pos.x) < SPAWNER.game.radar.size() && int(pos.y) >= 0 && int(pos.y) < SPAWNER.game.radar.size()):
			if(SPAWNER.game.radar[int(pos.x)][int(pos.y)] != 1):
				squares[i].anim = "LIGHT RED"
			else:
				squares[i].anim = "RED"
				building = false
				build_alert = "LOCATION OBSTRUCTED"
		else:
			squares[i].anim = "RED"
			building = false
			build_alert = "LOCATION OBSTRUCTED"
	#Test Prices
	if(SPAWNER.game.me.energy < energy_cost):
		building = false
		build_alert = "NOT ENOUGH ENERGY"
	if(SPAWNER.game.me.metal < metal_cost):
		building = false
		build_alert = "NOT ENOUGH METAL"
	if(SPAWNER.game.me.supply < supply_cost):
		building = false
		build_alert = "NOT ENOUGH SUPPLY"
	if(building == true):
		light_color = "FLASH"
		for i in range(squares.size()):
			squares[i].anim = "FLASH"
	else:
		light_color = "RED"
		for i in range(squares.size()):
			if(squares[i].anim == "FLASH"):
				squares[i].anim = "LIGHT RED"
	buildability = building

func _die():
	if(is_instance_valid(stats)):
		stats.hide()
		stats.queue_free()
		stats = null

func _build():
	var obj
	if(mousability == true):
		if(buildability == true):
			EVENTS.emit_signal("do_move",1,SPAWNER.game.me.id,buildid,round(position.x / 32),round(position.y / 32))
			if(Input.is_key_pressed(KEY_SHIFT) == false):
				EVENTS.emit_signal("cancel_build")
			obj = SPAWNER._spawn([SPAWNER.spawn_objs.EFFECT_BUILD_FLASH],null,position + center,Vector2(0,0),0,0,0)
			obj.scale = Vector2(.5 * (.5 + center.y / 32),.5 * (.5 + center.y / 32))
			SFX._play_new([4001])
		else:
			if(Input.is_key_pressed(KEY_SHIFT) == false):
				EVENTS.emit_signal("cancel_build")
			SFX._play_new([4002])

func _set_stats():
	if(stats != null):
		if(is_instance_valid(stats)):
			stats._set_stats(0,0,0,range_radius,shield_radius)
