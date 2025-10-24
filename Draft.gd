extends Node

var structures = [
	SPAWNER.spawn_objs.REACTOR,
	SPAWNER.spawn_objs.EXTRACTOR,
	SPAWNER.spawn_objs.SHIELD_AUXILIARY,
	SPAWNER.spawn_objs.HEAVY_SHIELD,
	SPAWNER.spawn_objs.BARRICADE
]
var turrets = [
	SPAWNER.spawn_objs.BLASTER_TURRET,
	SPAWNER.spawn_objs.DOUBLE_BLASTER,
	SPAWNER.spawn_objs.AUTOGUN,
	SPAWNER.spawn_objs.PHALANX,
	SPAWNER.spawn_objs.ARTILLERY,
	SPAWNER.spawn_objs.LASER_TURRET,
	SPAWNER.spawn_objs.LASERCANNON,
	SPAWNER.spawn_objs.MISSILE_TURRET,
	SPAWNER.spawn_objs.REPAIR_TURRET
]
var big_turrets = [
	SPAWNER.spawn_objs.MJOLNIR,
	SPAWNER.spawn_objs.PLASMACASTER,
	SPAWNER.spawn_objs.QUAD_MISSILE,
	SPAWNER.spawn_objs.HYPER_REPAIR_TURRET,
	SPAWNER.spawn_objs.AUTOCANNON
]
var fighters = [
	SPAWNER.spawn_objs.PIRANHA,
	SPAWNER.spawn_objs.RAPIER,
	SPAWNER.spawn_objs.SABER,
	SPAWNER.spawn_objs.MOSQUITO,
	SPAWNER.spawn_objs.HAWK,
	SPAWNER.spawn_objs.MANTIS,
	SPAWNER.spawn_objs.FURY
]
var corvettes = [
	SPAWNER.spawn_objs.PUMA,
	SPAWNER.spawn_objs.FALCON,
	SPAWNER.spawn_objs.GLADIATOR,
	SPAWNER.spawn_objs.KNIGHT
]
var frigates = [
	SPAWNER.spawn_objs.SPARTAN,
	SPAWNER.spawn_objs.GRENDAL,
	SPAWNER.spawn_objs.COBRA,
	SPAWNER.spawn_objs.MINOTAUR,
	SPAWNER.spawn_objs.ATHENA,
	SPAWNER.spawn_objs.SCORPION
]
var destroyers = [
	SPAWNER.spawn_objs.MYRMIDON
]
var cruisers = [
	SPAWNER.spawn_objs.TRIDENT,
	SPAWNER.spawn_objs.GOLIATH,
	SPAWNER.spawn_objs.BEAM_HALO,
	SPAWNER.spawn_objs.ARTILLERY_HALO,
	SPAWNER.spawn_objs.PLASMA_HALO,
	SPAWNER.spawn_objs.HAMMERHEAD,
	SPAWNER.spawn_objs.CATACLYSM
]

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
		if i < 10:
			s = _get_item("BIG SHIPS")
		if i >= 10 && i < 19:
			s = _get_item("SMALL SHIPS")
		if i >= 19:
			s = _get_item("STRUCTURES")
		good = _check_item(full_draft,s)
		if good:
			full_draft.append(s)
			i = i - 1
	return full_draft

func _check_item(d,s):
	var good = true
	for i in d.size():
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
