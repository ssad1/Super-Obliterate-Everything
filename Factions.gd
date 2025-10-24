extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _faction_colors(f):
	var flag = Color(1,1,1,1)
	var light = Color(1,1,1,1)
	var c
	match f:
		1: #BLUE
			flag = Color.from_hsv(.6, .8, 1, 1)
			light = Color.from_hsv(.6, .3, 1, 1)
		2: #TEAL
			flag = Color.from_hsv(.5, .8, 1, 1)
			light = Color.from_hsv(.7, .3, 1, 1)
		3: #RED
			flag = Color.from_hsv(1.0, .8, 1, 1)
			light = Color.from_hsv(1.05, .3, 1, 1)
		4: #YELLOW
			flag = Color.from_hsv(1.1, .8, 1, 1)
			light = Color.from_hsv(1.1, .4, 1, 1)
		5: #ORANGE
			flag = Color.from_hsv(1.05, .8, 1, 1)
			light = Color.from_hsv(1.0, .4, 1, 1)
		6: #PURPLE
			flag = Color.from_hsv(.7, .8, 1, 1)
			light = Color.from_hsv(.9, .3, 1, 1)
		#4,5,7,8:
		#	flag = Color.from_hsv(.4+.1 * f, .8, 1, 1)
		#	light = Color.from_hsv(.5 +.1 * f, .3, 1, 1)
	c = [flag,light]
	return c

func _faction_prizes(s, scale):
	var item_bag = []
	var odds = []
	item_bag = _faction_items(s,0)
	odds = [0.0, 0.05, 0.05, 0.125, 0.075, 0.025, 0.15, 0.1, 0.05, 0.025, 0.05]
	for i in range(1,item_bag.size(),1):
		if(CALC._rand() < scale * odds[i]):
			ACCOUNT.mission_prizes.append([0, item_bag[i]])

func _faction_items(s,v):
	var item_bag = []
	#v 0 standard
	#v 1 boss
	print("V: " + str(v))
	match s:
		2: #TEAL
			if(v == 0):
				item_bag.append([SPAWNER.spawn_objs.STATION])
			else:
				item_bag.append([SPAWNER.spawn_objs.BOSS_STATION])
			item_bag.append([SPAWNER.spawn_objs.REACTOR])
			item_bag.append([SPAWNER.spawn_objs.EXTRACTOR])
			item_bag.append([SPAWNER.spawn_objs.BLASTER_TURRET]) #Turret 1
			item_bag.append([SPAWNER.spawn_objs.LASER_TURRET]) #Turret 2
			item_bag.append([SPAWNER.spawn_objs.LASERCANNON]) #Turret 3
			item_bag.append([SPAWNER.spawn_objs.RAPIER]) #Ship 1
			item_bag.append([SPAWNER.spawn_objs.FALCON]) #Ship 2
			item_bag.append([SPAWNER.spawn_objs.SPARTAN]) #Ship 3
			item_bag.append([SPAWNER.spawn_objs.BEAM_HALO]) #Ship 4
			item_bag.append([SPAWNER.spawn_objs.SHIELD_AUXILIARY]) #Defense
		3: #RED
			if(v == 0):
				item_bag.append([SPAWNER.spawn_objs.STATION]) #Station
			else:
				item_bag.append([SPAWNER.spawn_objs.BOSS_STATION]) #Boss Station
			item_bag.append([SPAWNER.spawn_objs.REACTOR])
			item_bag.append([SPAWNER.spawn_objs.EXTRACTOR])
			item_bag.append([SPAWNER.spawn_objs.BLASTER_TURRET]) #Turret 1
			item_bag.append([SPAWNER.spawn_objs.AUTOGUN]) #Turret 2
			item_bag.append([SPAWNER.spawn_objs.MJOLNIR]) #Turret 3
			item_bag.append([SPAWNER.spawn_objs.PIRANHA]) #Ship 1
			item_bag.append([SPAWNER.spawn_objs.PUMA]) #Ship 2
			item_bag.append([SPAWNER.spawn_objs.ATHENA]) #Ship 3
			item_bag.append([SPAWNER.spawn_objs.TRIDENT]) #Ship 4
			item_bag.append([SPAWNER.spawn_objs.SHIELD_AUXILIARY]) #Defense
		4: #YELLOW
			if(v == 0):
				item_bag.append([SPAWNER.spawn_objs.STATION]) #Station
			else:
				item_bag.append([SPAWNER.spawn_objs.BOSS_STATION]) #Boss Station
			item_bag.append([SPAWNER.spawn_objs.REACTOR])
			item_bag.append([SPAWNER.spawn_objs.EXTRACTOR])
			item_bag.append([SPAWNER.spawn_objs.BLASTER_TURRET]) #Turret 1
			item_bag.append([SPAWNER.spawn_objs.DOUBLE_BLASTER]) #Turret 2
			item_bag.append([SPAWNER.spawn_objs.QUAD_MISSILE]) #Turret 3
			item_bag.append([SPAWNER.spawn_objs.MANTIS]) #Ship 1
			item_bag.append([SPAWNER.spawn_objs.KNIGHT]) #Ship 2
			item_bag.append([SPAWNER.spawn_objs.GRENDAL]) #Ship 3
			item_bag.append([SPAWNER.spawn_objs.HAMMERHEAD]) #Ship 4
			item_bag.append([SPAWNER.spawn_objs.PHALANX]) #Defense
		5: #ORANGE
			if(v == 0):
				item_bag.append([SPAWNER.spawn_objs.STATION]) #Station
			else:
				item_bag.append([SPAWNER.spawn_objs.BOSS_STATION]) #Boss Station
			item_bag.append([SPAWNER.spawn_objs.REACTOR])
			item_bag.append([SPAWNER.spawn_objs.EXTRACTOR])
			item_bag.append([SPAWNER.spawn_objs.BLASTER_TURRET]) #Turret 1
			item_bag.append([SPAWNER.spawn_objs.DOUBLE_BLASTER]) #Turret 2
			item_bag.append([SPAWNER.spawn_objs.PLASMACASTER]) #Turret 3
			item_bag.append([SPAWNER.spawn_objs.FURY]) #Ship 1
			item_bag.append([SPAWNER.spawn_objs.SCORPION]) #Ship 2
			item_bag.append([SPAWNER.spawn_objs.MYRMIDON]) #Ship 3
			item_bag.append([SPAWNER.spawn_objs.GOLIATH]) #Ship 4
			item_bag.append([SPAWNER.spawn_objs.SHIELD_AUXILIARY]) #Defense
		6: #PURPLE
			if(v == 0):
				item_bag.append([SPAWNER.spawn_objs.STATION]) #Station
			else:
				item_bag.append([SPAWNER.spawn_objs.BOSS_STATION]) #Boss Station
			item_bag.append([SPAWNER.spawn_objs.REACTOR])
			item_bag.append([SPAWNER.spawn_objs.EXTRACTOR])
			item_bag.append([SPAWNER.spawn_objs.BLASTER_TURRET]) #Turret 1
			item_bag.append([SPAWNER.spawn_objs.DOUBLE_BLASTER]) #Turret 2
			item_bag.append([SPAWNER.spawn_objs.AUTOCANNON]) #Turret 3
			item_bag.append([SPAWNER.spawn_objs.RAPIER]) #Ship 1
			item_bag.append([SPAWNER.spawn_objs.MINOTAUR]) #Ship 2
			item_bag.append([SPAWNER.spawn_objs.SCORPION]) #Ship 3
			item_bag.append([SPAWNER.spawn_objs.CATACLYSM]) #Ship 4
			item_bag.append([SPAWNER.spawn_objs.PHALANX]) #Defense
	return item_bag
