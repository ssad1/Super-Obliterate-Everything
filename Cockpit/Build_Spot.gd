extends Node2D

var squares = []
var dimensions:Vector2 = Vector2(1,1)
var center:Vector2 = Vector2(0,0)
var buildability:bool = false
var mousability:bool = false
var buildid:int = 0
var build_flag:int = 0
var energy_cost:float = 0
var metal_cost:float = 0
var supply_cost:int = 0
var range_radius:int = 0
var shield_radius:int = 0
var build_alert:String = ""
var old_build_alert:String = ""

var has_stats:bool = false
@onready var dummy_stat:Stats

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:

	_color_squares()
	_check_mouse()

	if has_stats and is_instance_valid(dummy_stat):
		dummy_stat.position = position + center
	if old_build_alert != build_alert:
		EVENTS.emit_signal("build_alert", build_alert)
		old_build_alert = build_alert

func _input(event: InputEvent) -> void:

	var key_press = event as InputEventMouseButton

	if key_press == null: return
	if !key_press.pressed: return

	match key_press.button_index:
		MOUSE_BUTTON_RIGHT:
			EVENTS.emit_signal("cancel_build")
		MOUSE_BUTTON_LEFT:
			if build_flag == 0:
				_build()
		MOUSE_BUTTON_LEFT:
			build_flag = 1
		MOUSE_BUTTON_LEFT:
			build_flag = 0

func _check_mouse() -> void:
	var m := get_viewport().get_mouse_position()
	var v := Vector2(GLOBAL.resx, GLOBAL.resy)
	m = m / v
	if m.x < .265 && m.y > .76:
		mousability = false
	else:
		mousability = true

func _clear_squares() -> void:
	for i in squares.size():
		squares[i].queue_free()
	squares = []

func _ignite(id:int, v:Vector2, price:Array, r:float, sr:float) -> void:
	var s
	_clear_squares()
	buildid = id
	dimensions = v
	energy_cost = price[0]
	metal_cost = price[1]
	supply_cost = price[2]
	range_radius = r
	shield_radius = sr

	for i in v.x:
		for j in v.y:
			s = GLOBAL.Square.instantiate()
			add_child(s)
			s.set_position(Vector2(32 * i, 32 * j))
			squares.append(s)

	center = dimensions * 16

	_init_dummy_stat()

func _init_dummy_stat() -> void:
	dummy_stat = Stats.stat_node.instantiate()
	SPAWNER.game.super_add_child(dummy_stat)
	dummy_stat.position = position + center
	dummy_stat.modulate = Color(1,1,1,1)
	has_stats = true

	Stats.do_build_range(dummy_stat, range_radius, shield_radius)


func _color_squares() -> void:
	#var xx = 0
	#var yy = 0
	var pos := Vector2(0,0)
	var building := true
	var light_color := "FLASHING"
	build_alert = ""

	#Test Squares

	for i in squares.size():
		pos = (squares[i].position + self.position) / 32
		if (
		int(pos.x) >= 0 && 
		int(pos.x) < SPAWNER.game.radar.size() && 
		int(pos.y) >= 0 && 
		int(pos.y) < SPAWNER.game.radar.size()
		):
			if SPAWNER.game.radar[int(pos.x)][int(pos.y)] != 1:
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
	if SPAWNER.game.me.energy < energy_cost:
		building = false
		build_alert = "NOT ENOUGH ENERGY"
	if SPAWNER.game.me.metal < metal_cost:
		building = false
		build_alert = "NOT ENOUGH METAL"
	if SPAWNER.game.me.supply < supply_cost:
		building = false
		build_alert = "NOT ENOUGH SUPPLY"
	if building:
		light_color = "FLASH"
		for i in squares.size():
			squares[i].anim = "FLASH"
	else:
		light_color = "RED"
		for i in squares.size():
			if squares[i].anim == "FLASH":
				squares[i].anim = "LIGHT RED"
	buildability = building

func die() -> void:
	dummy_stat.hide()
	dummy_stat.queue_free()
	dummy_stat = null

func _build() -> void:
	var obj

	if !mousability: return
	
	if buildability:
		EVENTS.emit_signal("do_move",1,SPAWNER.game.me.id,buildid,round(position.x / 32),round(position.y / 32))
		if !Input.is_key_pressed(KEY_SHIFT):
			EVENTS.emit_signal("cancel_build")
		obj = SPAWNER._spawn([SPAWNER.spawn_objs.EFFECT_BUILD_FLASH],null,position + center,Vector2(0,0),0,0,0)
		obj.scale = Vector2(.5 * (.5 + center.y / 32),.5 * (.5 + center.y / 32))
		SFX._play_new([SFX.sound.BUTTON_BUILD])
	else:
		if !Input.is_key_pressed(KEY_SHIFT):
			EVENTS.emit_signal("cancel_build")
		SFX._play_new([SFX.sound.BUILD_ERROR])
