extends Node

var structures = [250,251,1000,1001,1002]
var turrets = [300,301,302,303,304,305,306,307,308]
var big_turrets = [500,501,502,503,504]
var fighters = [2000,2001,2002,2004,2005,2006,2007]
var corvettes = [2501,2502,2503,2504]
var frigates = [3000,3002,3004,3005,3006,3007]
var destroyers = [3500]
var cruisers = [4000,4001,4002,4003,4004,4005,4006]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _gen_draft(sd):
	var full_draft = []
	var i = 27
	var s
	var good = false
	while i > 0:
		if (i < 10):
			s = _get_item("BIG SHIPS")
		if(i >= 10 && i < 19):
			s = _get_item("SMALL SHIPS")
		if(i >= 19):
			s = _get_item("STRUCTURES")
		good = _check_item(full_draft,s)
		if(good == true):
			full_draft.append(s)
			i = i - 1
	return full_draft

func _check_item(d,s):
	var good = true
	for i in range(d.size()):
		if(d[i] == s):
			good = false
	return good

func _get_item(item_type):
	var s = []
	var all_items = structures + turrets + big_turrets + fighters + corvettes + frigates + destroyers + cruisers
	match item_type:
		"BASIC":
			s = _pick_item(all_items)
		"STRUCTURES":
			s = _pick_item(structures + turrets + big_turrets)
		"SMALL SHIPS":
			s = _pick_item(fighters + corvettes)
		"BIG SHIPS":
			s = _pick_item(frigates + destroyers + cruisers)
	return s

func _pick_item(item_array):
	var s = []
	var id = CALC._randint() % item_array.size()
	s = [item_array[id]]
	return s
