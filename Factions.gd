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
				item_bag.append([200]) #Station
			else:
				item_bag.append([230]) #Boss Station
			item_bag.append([250]) #Reactor
			item_bag.append([251]) #Extractor
			item_bag.append([300]) #Turret 1
			item_bag.append([305]) #Turret 2
			item_bag.append([306]) #Turret 3
			item_bag.append([2001]) #Ship 1
			item_bag.append([2502]) #Ship 2
			item_bag.append([3000]) #Ship 3
			item_bag.append([4002]) #Ship 4
			item_bag.append([1001]) #Defense
		3: #RED
			if(v == 0):
				item_bag.append([200]) #Station
			else:
				item_bag.append([230]) #Boss Station
			item_bag.append([250]) #Reactor
			item_bag.append([251]) #Extractor
			item_bag.append([300]) #Turret 1
			item_bag.append([302]) #Turret 2
			item_bag.append([500]) #Turret 3
			item_bag.append([2000]) #Ship 1
			item_bag.append([2501]) #Ship 2
			item_bag.append([3006]) #Ship 3
			item_bag.append([4000]) #Ship 4
			item_bag.append([1001]) #Defense
		4: #YELLOW
			if(v == 0):
				item_bag.append([200]) #Station
			else:
				item_bag.append([230]) #Boss Station
			item_bag.append([250]) #Reactor
			item_bag.append([251]) #Extractor
			item_bag.append([300]) #Turret 1
			item_bag.append([301]) #Turret 2
			item_bag.append([503]) #Turret 3
			item_bag.append([2006]) #Ship 1
			item_bag.append([2504]) #Ship 2
			item_bag.append([3002]) #Ship 3
			item_bag.append([4005]) #Ship 4
			item_bag.append([303]) #Defense
		5: #ORANGE
			if(v == 0):
				item_bag.append([200]) #Station
			else:
				item_bag.append([230]) #Boss Station
			item_bag.append([250]) #Reactor
			item_bag.append([251]) #Extractor
			item_bag.append([300]) #Turret 1
			item_bag.append([301]) #Turret 2
			item_bag.append([502]) #Turret 3
			item_bag.append([2007]) #Ship 1
			item_bag.append([3007]) #Ship 2
			item_bag.append([3500]) #Ship 3
			item_bag.append([4001]) #Ship 4
			item_bag.append([1001]) #Defense
		6: #PURPLE
			if(v == 0):
				item_bag.append([200]) #Station
			else:
				item_bag.append([230]) #Boss Station
			item_bag.append([250]) #Reactor
			item_bag.append([251]) #Extractor
			item_bag.append([300]) #Turret 1
			item_bag.append([301]) #Turret 2
			item_bag.append([501]) #Turret 3
			item_bag.append([2001]) #Ship 1
			item_bag.append([3005]) #Ship 2
			item_bag.append([3007]) #Ship 3
			item_bag.append([4006]) #Ship 4
			item_bag.append([303]) #Defense
	return item_bag
