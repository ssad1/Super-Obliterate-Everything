extends Node2D

var planet_system
var radar:Array = []
var players:Array = []
var ships:Array[Ship_General] = []
var structs:Array[Struct_General] = []
var lasers:Array[Laser_General] = []
var missiles:Array[Ship_Missile] = []
var shots:Array = []
var explosions:Array = []
var rocks:Array = []
var event_list:Array = []
var mapsize:Vector2 = Vector2(32*128,32*128)
var wint:float = 0
var wint_on:bool = false
var tick_clock:float = 0
var me
var tx_moves:Array[Array] = []
var rx_moves:Array[Array] = []
var victory_condition:String = ""
var victory_flag:int = 0 #not done, defeat, victory ... +10 Confirmed
var victory_t:int = 20
var victory_clock:int = -1
var mission_id:int = 0
var mission_difficulty:float = 0
var mission_clock:int = 0
var title_clock:float = 0

func _ready() -> void:
	SPAWNER.game = self
	EVENTS.connect("flipload", Callable(self, "_flipload"))
	EVENTS.connect("do_move", Callable(self, "_do_move"))

func _process(delta:float) -> void:

	if GLOBAL.gamemode != 0:
		_control()
	else:
		title_clock = title_clock + delta
		_control_title()
	
	if GLOBAL.gamemode != 2: return

	tick_clock = tick_clock + delta
	if tick_clock > 0.1:
		tick_clock = tick_clock - 0.1
		_do_tick()
	if tick_clock > 0.2:
		tick_clock = 0.2
	
	#Victory
	if !wint_on: return
	wint = wint + delta

	if !SPAWNER.results.visible && wint > 50:
		EVENTS.emit_signal("show_results",1)
		wint = 0
		wint_on = false
	
func _cam_offset() -> Vector2:
	var pos := position
	return Vector2(GLOBAL.resx / 2 - (pos.x + .5 * mapsize.x), GLOBAL.resy / 2 - (pos.y + .5 * mapsize.y))

func _control() -> void:

	position += Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up") * 24
	
	'''
	if get_global_mouse_position().x < 16:
		position.x = position.x + 1000 * delta
	if get_global_mouse_position().x > GLOBAL.resx - 16:
		position.x = position.x - 1000 * delta
	if get_global_mouse_position().y < 16:
		position.y = position.y + 1000 * delta
	if get_global_mouse_position().y > GLOBAL.resy - 16:
		position.y = position.y - 1000 * delta'''
	
	_camera_edges()

func _control_title() -> void:
	position.x = 24000 * cos(0.1 * title_clock)
	position.y = 24000 * sin(0.1 * title_clock)
	#print(title_clock)

func _center_camera(pos:Vector2) -> void:
	position.x = -1 * pos.x + 0.5 * GLOBAL.resx
	position.y = -1 * pos.y + 0.5 * GLOBAL.resy
	_camera_edges()

func _camera_edges() -> void:
	if position.x > 0:
		position.x = 0
	if position.x + mapsize.x < GLOBAL.resx:
		position.x = -1 * mapsize.x + GLOBAL.resx
	if position.y > 0:
		position.y = 0
	if position.y + mapsize.y < GLOBAL.resy:
		position.y = -1 * mapsize.y + GLOBAL.resy

func _collide() -> void:
	for shot in shots:
		for target in shot.tcpu.targets:

			if !is_instance_valid(target): continue

			var sizeSX:float = shot.hitbox.size.x
			var sizeTX:float = target.hitbox.size.x

			var sizeSY:float = shot.hitbox.size.y
			var sizeTY:float = target.hitbox.size.y

			var shot_pos:Vector2 = shot.hitbox.global_position
			var target_pos:Vector2 = target.hitbox.global_position

			if (
			(shot.hitbox != null && target.hitbox != null) && 
			(shot_pos.x + sizeSX > target_pos.x - sizeTX) && 
			(shot_pos.x - sizeSX < target_pos.x + sizeTX) && 
			(shot_pos.y + sizeSY > target_pos.y - sizeTY) && 
			(shot_pos.y - sizeSY < target_pos.y + sizeTY)):
				target._hit(shot)

	for missile in missiles:
		for target in missile.tcpu.targets:

			if !is_instance_valid(target): continue

			var sizeSX:float = missile.hitbox.size.x
			var sizeTX:float = target.hitbox.size.x

			var sizeSY:float = missile.hitbox.size.y
			var sizeTY:float = target.hitbox.size.y

			var missile_pos:Vector2 = missile.hitbox.global_position
			var target_pos:Vector2 = target.hitbox.global_position

			if(
			(missile.hitbox != null && target.hitbox != null) &&
			(missile_pos.x + sizeSX > target_pos.x - sizeTX) && 
			(missile_pos.x - sizeSX < target_pos.x + sizeTX) &&
			(missile_pos.y + sizeSY > target_pos.y - sizeTY) && 
			(missile_pos.y - sizeSY < target_pos.y + sizeTY)):
				target._hit(missile)

func _collide_explosions() -> void:
	for explosion in explosions:
		explosion.tcpu._clean_targets()

		for target in explosion.tcpu.targets:

			if target.hitbox == null: continue

			var d2:float = target.hitbox.size.x
			if target.hitbox.size.y > d2:
				d2 = target.hitbox.size.y

			if explosion.pos.distance_to(target.pos) < explosion.boom_radius + d2:
				target._hit(explosion)

func _collide_shields() -> void:
	for struct in structs:
		for module in struct.modules:

			if module.is_type == "SHIELD" && module.shield > 0:
				_collide_shields_b(struct.player.id, module)

func _collide_shields_b(f,s) -> void:
	for shot in shots:
		if shot.is_type != "LASER" && DIPLOMACY.grid[shot.player.id][f] == 0:
			_collide_shields_c(shot,s)
			
	for missile in missiles:
		if DIPLOMACY.grid[missile.player.id][f] == 0:
			_collide_shields_c(missile,s)

func _collide_shields_c(sa,sb) -> void:
	var d = sa.pos.distance_to(sb.pos)
	if d < sb.shield_radius + 0.5 * sb.shield_width && d > sb.shield_radius - 0.5 * sb.shield_width:
		sa.armor = 0
		SPAWNER._spawn_hit("SHIELD", sa.damage, sa.pos, Vector2(0,0), sa.rotate + PI)
		sb._hit_shield(sa.damage,sa.pos)

func _clear_game() -> void:
	print("Clear Game")
	me = null
	players = []
	structs = []
	missiles = []
	shots = []
	ships = []
	lasers = []
	explosions = []

	if has_node("Sunshine"):
		get_node("Sunshine").queue_free()

	EVENTS.emit_signal("clear_build_layer")
	for child in get_children():
		while child.get_child_count() > 0:
			child.remove_child(child.get_child(0))

func _do_event_list() -> void:
	for event in event_list:

		if mission_clock <= event[1] || mission_clock >= event[2] : continue

		if event[3] <= 0 :
			event[3] = event[4]
			if event[0] == 1:
				players[event[5]]._do_event(event)
		else:
			event[3] = event[3] - 1

func _do_move(p,type,s,posx,posy) -> void:
	tx_moves[p] = [p,type,s,posx,posy]

func _do_rx_moves() -> void:
	if GLOBAL.gamemode == 2:
		rx_moves = tx_moves

	for i in rx_moves.size():

		var move := rx_moves[i]

		if move.size() > 0 && move[1] == 1:
			players[move[0]]._build(move)

		move = []
		tx_moves[i] = []

func _do_tick() -> void:
	var start_clock = Time.get_ticks_usec()
	var end_clock
	mission_clock = mission_clock + 1
	_do_event_list()
	_do_radar()
	_collide()
	_collide_explosions()
	_collide_shields()
	_do_rx_moves()
	_do_thing(structs)
	_do_thing(ships)
	_do_thing(missiles)
	_do_thing(shots)
	_do_thing(lasers)
	_do_thing(explosions)
	SFX._do_tick()
	_remove_thing(structs)
	_remove_thing(ships)
	_remove_thing(missiles)
	_remove_thing(shots)
	_remove_thing(lasers)
	_remove_thing(explosions)
	for player in players:
		player._do_tick()
	_do_victory()
	GLOBAL.heatbright = GLOBAL.heatbright * .9 - 1
	end_clock = Time.get_ticks_usec()
	if mission_clock % 10 == 0:
		print("Code Time: " + str(end_clock - start_clock))

func _do_radar() -> void:
	var pos:Vector2
	var build_obj
	var data

	radar = []
	for xx in LEVELS.grid.size():
		radar.append([])

		radar[xx] = []
		for yy in LEVELS.grid[0].size():
			radar[xx].append([])
			radar[xx][yy] = 0

	rocks = []

	for struct in structs:
		pos = struct.position
		pos.x = round(pos.x - 16 * struct.build_size.x) / 32
		pos.y = round(pos.y - 16 * struct.build_size.y) / 32

		for xx in struct.build_size.x:
			for yy in struct.build_size.y:
				radar[pos.x + xx][pos.y + yy] = 1

		if struct.special == "ROCK":
			rocks.append(struct)

	for ship in ships:

		if ship.build_mission == null: continue

		data = ship.build_mission

		var data2 = data[2]

		if "factory" in players[data[0]].item_bag_objs[data2]:
			build_obj = players[data[0]].item_bag_factory_objs[data2]
		else:
			build_obj = players[data[0]].item_bag_objs[data2]
		pos.x = data[3]
		pos.y = data[4]
		for xx in build_obj.build_size.x:
			for yy in build_obj.build_size.y:
				if radar[pos.x + xx][pos.y + yy] == 0:
					radar[pos.x + xx][pos.y + yy] = 2

func _do_thing(a) -> void:
	var i:int = a.size() - 1
	var s
	while i >= 0:
		s = a[i]
		s._do_tick()

		if s.dead:
			s.queue_free()
			a.remove_at(i)
		i = i - 1

func _remove_thing(a) -> void:
	var i:int = a.size() - 1
	var s
	var sid:int = 0
	while i >= 0:
		s = a[i]
		if s.dead:
			if "spawn_id" in a:
				sid = a.spawn_id
			s.queue_free()
			a.remove_at(i)
			_remove_refs(sid)
		i = i - 1

func _remove_refs(sid) -> void:
	_remove_refs_sub(ships,sid)
	_remove_refs_sub(structs,sid)
	_remove_refs_sub(missiles,sid)
	_remove_refs_sub(shots,sid)
	_remove_refs_sub(lasers,sid)
	_remove_refs_sub(explosions,sid)
	
func _remove_refs_sub(a,sid) -> void:
	for i in a:
		i._remove_ref(sid)

func _do_victory() -> void:
	if victory_t > 0:
		victory_t = victory_t - 1
	if victory_flag < 10 && victory_t == 0:
		victory_flag = 0
		match victory_condition:
			"DUEL","SKIRMISH","BOSS":
				victory_flag = 2
				for i in players.size():
					if !players[i].dead && DIPLOMACY.grid[me.id][i] == 0:
						victory_flag = 0
				if me.dead:
					victory_flag = 1
			"DEFENSE":
				#print(victory_condition)
				#print(mission_clock)
				#print(victory_clock)
				if mission_clock >= victory_clock:
					victory_flag = 2
				for i in ships.size():
					if ships[i].player.id != me.id && DIPLOMACY.grid[me.id][ships[i].player.id] == 0:
						victory_flag = 0
				if me.dead:
					victory_flag = 1
		if victory_flag != 0:
			EVENTS.emit_signal("cancel_build")
			EVENTS.emit_signal("show_results",victory_flag)
			if victory_flag == 2:
				EVENTS.emit_signal("set_results",1,mission_id)
				if victory_condition == "BOSS":
					EVENTS.emit_signal("campaign_complete")
			victory_flag = victory_flag + 10

func _flipload() -> void:
	if GLOBAL.nextscreen == 0:
		hide()
		_clear_game()
	if GLOBAL.nextscreen == 1:
		hide()
		_clear_game()
	if GLOBAL.nextscreen == 2:
		_start_game()
		show()
		EVENTS.emit_signal("flipout")

func _set_players() -> void:
	for player in players:
		if player.faction == 1:
			player._set_me_player()
			player._setup_station()
			player._setup_resources(LEVELS.level_resources)
		if player.faction > 1:
			player._set_cpu(mission_difficulty)
			player._setup_station()
			player._setup_base()
			player._setup_resources(LEVELS.level_resources)

func _super_add_child(obj) -> void:
	add_child(obj)
	remove_child(obj)
	if obj.is_type == "STRUCT":
		$Layer_Structs.add_child(obj)
		structs.append(obj)
	if obj.is_type == "SHIP":
		$Layer_Ships.add_child(obj)
		ships.append(obj)
	if obj.is_type == "MISSILE":
		$Layer_Shots.add_child(obj)
		missiles.append(obj)
	if obj.is_type == "SHOT":
		$Layer_Shots.add_child(obj)
		shots.append(obj)
	if obj.is_type == "LASER":
		$Layer_Shots.add_child(obj)
		lasers.append(obj)
	if obj.is_type == "EXPLODE":
		$Layer_Shots.add_child(obj)
		explosions.append(obj)
	if obj.is_type == "EFFECT":
		if obj.effect_layer == 0:
			$Layer_Effects_Normal.add_child(obj)
		else:
			$Layer_Effects_Bright.add_child(obj)
	if obj.is_type == "STATS":
		$Layer_Stats.add_child(obj)

func _screen_shake():
	pass

func _start_game() -> void:
	var bonus = 0
	GLOBAL.gamemode = 2

	var sunshine = GLOBAL.Sunshine.instantiate()

	add_child(sunshine)

	victory_t = 20
	LEVELS._design_level()
	victory_condition = LEVELS.level_mission
	mission_id = LEVELS.mission_id
	mission_difficulty = LEVELS.mission_difficulty
	victory_clock = LEVELS.victory_clock
	event_list = LEVELS.event_list
	planet_system._gen_planets()
	_do_radar()
	_set_players()

	if me.my_stations.size() > 0:
		_center_camera(Vector2(me.my_stations[0].pos.x, me.my_stations[0].pos.y))
	else:
		_center_camera(Vector2(mapsize.x / 2, mapsize.y / 2))

	wint_on = false
	victory_flag = 0
	rx_moves = []
	tx_moves = []

	for i in players:
		rx_moves.append([])
		tx_moves.append([])

	ACCOUNT.mission_prizes = []

	if LEVELS.level_mission == "BOSS":
		bonus = 20 * mission_difficulty

	bonus = bonus + round(randf() * 5 * mission_difficulty)
	ACCOUNT.mission_prizes.append([1,round(5 + 10 * mission_difficulty + bonus)])

	for i in players.size():
		if i > 1:
			FACTIONS._faction_prizes(players[i].faction,1 / (players.size() - 2))

	mission_clock = 0
	tick_clock = 0
	
