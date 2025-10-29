extends Node

var campaign_seed = 3000
var campaign_id = 0
var campaign_danger = 1
var mission_results = []
var mission_prizes = [] #Example: [[1,100],[0,[4001]],[0,[4000]],[0,[2500]]]
var mission_prize_ids = []
var campaign_dangers = []

var item_bag = []
var item_max = 100
var equip_bags = []
var current_equip = 0
var credits = 500

func _ready():
	EVENTS.connect("set_results", Callable(self, "_set_results"))
	EVENTS.connect("show_results", Callable(self, "_clear_prizes"))
	EVENTS.connect("clear_prizes", Callable(self, "_clear_prizes"))
	EVENTS.connect("draft_buy", Callable(self, "_draft_buy"))
	EVENTS.connect("campaign_complete", Callable(self, "_campaign_complete"))

	_default_stats()
	_default_items()
	_default_equip()
	_init_dangers()
	#_load_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _count_spaces():
	var spaces = 0
	var total_items = 0
	for i in item_bag.size():
		if item_bag[i] != null:
			total_items = total_items + 1
	spaces = item_max - total_items
	return spaces

func _default_stats():
	credits = 5000 #TEST normal 500

func _default_equip():
	var section = []
	equip_bags = []
	for i in range(9):
		section = []
		for j in range(18):
			section.append(null)
		equip_bags.append(section)
	equip_bags[0][0] = 0
	equip_bags[0][1] = 1
	equip_bags[0][2] = 2
	equip_bags[0][3] = 3
	equip_bags[0][6] = 4
	equip_bags[0][7] = 5
	equip_bags[0][8] = 6
	equip_bags[0][9] = 7

func _default_items():
	var i
	item_bag.append([SPAWNER.spawn_objs.REACTOR])
	item_bag.append([SPAWNER.spawn_objs.EXTRACTOR])
	item_bag.append([SPAWNER.spawn_objs.BLASTER_TURRET])
	item_bag.append([SPAWNER.spawn_objs.AUTOGUN])
	item_bag.append([SPAWNER.spawn_objs.PIRANHA])
	item_bag.append([SPAWNER.spawn_objs.RAPIER])
	item_bag.append([SPAWNER.spawn_objs.MOSQUITO])
	item_bag.append([SPAWNER.spawn_objs.PUMA])
	#item_bag.append([SPAWNER.spawn_objs.LEGION])

func _draft_buy(price, item):
	var buy = true
	var err = ""
	if(credits < price):
		buy = false
		err = "POOR"
	if(_count_spaces() == 0):
		buy = false
		err = "FULL"
	if(buy == true):
		credits = credits - price
		_add_item(item)
		print("BOUGHT")
		EVENTS.emit_signal("draft_bought")
	if(err != ""):
		EVENTS.emit_signal("draft_error", err)

func _equip_item(id,item_id):
	equip_bags[current_equip][id] = item_id
	#_save_game()

func _get_item_id(id):
	var r
	r = equip_bags[current_equip][id]
	return r

func _gen_mission_results(missions):
	if(mission_results.size() == 0):
		mission_results = []
		for i in range(missions.size()):
			mission_results.append(0)

func _set_results(r,m):
	print("SET RESULTS")
	print(str(r) + " " + str(m))
	if(m < mission_results.size() && m >= 0):
		mission_results[m] = r
	print(mission_results)
	_save_game()

func _init_dangers():
	for i in range(100):
		campaign_dangers.append(1)
	#campaign_dangers[0] = 10

func _fetch_danger(id):
	var d = 0
	d = campaign_dangers[id]
	return d

func _new_campaign(z_id, z_danger):
	mission_results = []
	randomize()
	campaign_seed = randi() % 10000000
	campaign_id = z_id
	campaign_danger = z_danger
	_save_game()

func _campaign_complete():
	mission_prizes.insert(0,[2,0])
	campaign_dangers[campaign_id] = campaign_dangers[campaign_id] + 1
	campaign_danger = campaign_danger + 1
	_new_campaign(campaign_id,campaign_danger)
	EVENTS.emit_signal("button_generate_pressed")

func _load_game():
	print("load game")
	var save_game = FileAccess.open("user://oedata.save", FileAccess.READ)
	if not save_game.file_exists("user://oedata.save"):
		return # Error! We don't have a save to load.
	var data = JSON.parse_string(save_game.get_line())
	campaign_seed = int(data["campaign_seed"])
	campaign_id = data["campaign_id"]
	campaign_danger = data["campaign_danger"]
	campaign_dangers = data["campaign_dangers"]
	mission_results = data["mission_results"]
	item_bag = data["item_bag"]
	equip_bags = data["equip_bags"]
	credits = data["credits"]
	save_game.close()
	print("load complete")
	print(equip_bags)

func _save_game():
	var save_game = FileAccess.open("user://oedata.save", FileAccess.WRITE)
	var save_dict = {
		"game version" : 0.02,
		"campaign_seed" : campaign_seed,
		"campaign_id" : campaign_id,
		"campaign_danger" : campaign_danger,
		"campaign_dangers" : campaign_dangers,
		"mission_results" : mission_results,
		"item_bag" : item_bag,
		"equip_bags" : equip_bags,
		"credits" : credits
	}
	print("SAVING CAMPAIGN")
	save_game.store_line(JSON.stringify(save_dict))
	save_game.close()
	print("SAVE SUCCESSFUL")

func _add_item(s):
	var id
	var added = false
	for i in item_bag.size():
		if item_bag[i] == null && !added:
			item_bag[i] = s
			added = true
			id = i
			i = item_bag.size()
	if !added:
		item_bag.append(s)
		id = item_bag.size() - 1
	return id

func _sell_item(id,price):
	credits = credits + price
	item_bag[id] = null
	_unequip(id)

func _sell_prize_item(id,price):
	_sell_item(mission_prize_ids[id],price)
	_save_game()

func _check_equipped(id):
	var e = false
	for i in range(equip_bags.size()):
		for j in range(equip_bags[i].size()):
			if(equip_bags[i][j] == id):
				e = true
	return e

func _unequip(id):
	for i in range(equip_bags.size()):
		for j in range(equip_bags[i].size()):
			if(equip_bags[i][j] == id):
				equip_bags[i][j] = null

func _do_prizes():
	var id
	mission_prize_ids = []
	for i in range(mission_prizes.size()):
		id = null
		match mission_prizes[i][0]:
			0:
				id = _add_item(mission_prizes[i][1])
			1:
				credits = credits + mission_prizes[i][1]
		if(id != null):
			mission_prize_ids.append(id)
		else:
			mission_prize_ids.append(null)
	mission_prizes = []
	_save_game()

func _clear_prizes(s):
	if(s == 1): #Clear prizes on defeat
		mission_prizes = []
