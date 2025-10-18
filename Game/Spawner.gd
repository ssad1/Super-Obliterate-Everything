extends Node

@onready var game
@onready var solarsystem
@onready var results
@onready var build_button
@onready var gui

@onready var Player = load("res://Player.gd")

@onready var Stats = load("res://Game/Stats/Stats.tscn")

@onready var E_ClickBoom = load("res://Effects/E_ClickBoom.tscn")
@onready var E_FireworkA = load("res://Effects/E_FireworkA.tscn")
@onready var E_FireworkB = load("res://Effects/E_FireworkB.tscn")
@onready var E_BigFirework = load("res://Effects/E_BigFirework.tscn")
@onready var E_AsteroidBoomT = load("res://Effects/E_AsteroidBoomT.tscn")
@onready var E_AsteroidBoomS = load("res://Effects/E_AsteroidBoomS.tscn")
@onready var E_AsteroidBoomL = load("res://Effects/E_AsteroidBoomL.tscn")
@onready var E_BoomStation = load("res://Effects/E_BoomStation.tscn")
@onready var E_BoomSmall = load("res://Effects/E_BoomSmall.tscn")
@onready var E_SparksM = load("res://Effects/E_SparksM.tscn")
@onready var E_Miner_Flash = load("res://Effects/E_Miner_Flash.tscn")
@onready var E_Impact_Kinetic = load("res://Effects/E_Impact_Kinetic.tscn")
@onready var E_Impact_Laser = load("res://Effects/E_Impact_Laser.tscn")
@onready var E_Impact_Mining = load("res://Effects/E_Impact_Mining.tscn")
@onready var E_Impact_Phalanx = load("res://Effects/E_Impact_Phalanx.tscn")
@onready var E_Impact_Repair = load("res://Effects/E_Impact_Repair.tscn")
@onready var E_Impact_Shield = load("res://Effects/E_Impact_Shield.tscn")
@onready var E_Boom1 = load("res://Effects/Explosions/E_Boom1.tscn")
@onready var E_Boom2 = load("res://Effects/Explosions/E_Boom2.tscn")
@onready var E_Boom3 = load("res://Effects/Explosions/E_Boom3.tscn")
@onready var E_Boom4 = load("res://Effects/Explosions/E_Boom4.tscn")
@onready var E_Boom5 = load("res://Effects/Explosions/E_Boom5.tscn")
@onready var E_BoomPuff1 = load("res://Effects/Explosions/E_BoomPuff1.tscn")
@onready var E_BoomPuff2 = load("res://Effects/Explosions/E_BoomPuff2.tscn")
@onready var E_BoomPuff3 = load("res://Effects/Explosions/E_BoomPuff3.tscn")
@onready var E_BoomPuff4 = load("res://Effects/Explosions/E_BoomPuff4.tscn")
@onready var E_BoomPuff5 = load("res://Effects/Explosions/E_BoomPuff5.tscn")
@onready var E_Flare1 = load("res://Effects/Explosions/E_Flare1.tscn")
@onready var E_Flare2 = load("res://Effects/Explosions/E_Flare2.tscn")
@onready var E_Flare3 = load("res://Effects/Explosions/E_Flare3.tscn")
@onready var E_Flare4 = load("res://Effects/Explosions/E_Flare4.tscn")
@onready var E_Flare5 = load("res://Effects/Explosions/E_Flare5.tscn")
@onready var E_Smoke1 = load("res://Effects/Explosions/E_Smoke1.tscn")
@onready var E_Smoke2 = load("res://Effects/Explosions/E_Smoke2.tscn")
@onready var E_Smoke3 = load("res://Effects/Explosions/E_Smoke3.tscn")
@onready var E_Smoke4 = load("res://Effects/Explosions/E_Smoke4.tscn")
@onready var E_Smoke5 = load("res://Effects/Explosions/E_Smoke5.tscn")
@onready var E_PlasmaBoom1 = load("res://Effects/Explosions/E_PlasmaBoom1.tscn")
@onready var E_PlasmaBoom2 = load("res://Effects/Explosions/E_PlasmaBoom2.tscn")
@onready var E_PlasmaBoom3 = load("res://Effects/Explosions/E_PlasmaBoom3.tscn")
@onready var E_Flash_Bloom = load("res://Effects/Explosions/E_Flash_Bloom.tscn")
@onready var E_Credits = load("res://Effects/E_Credits.tscn")
@onready var E_BuildFlash = load("res://Effects/E_BuildFlash.tscn")
@onready var E_PlasmaFlash = load("res://Effects/Explosions/E_PlasmaFlash.tscn")
@onready var E_Pang1 = load("res://Effects/Explosions/E_Pang1.tscn")
@onready var E_Pang2 = load("res://Effects/Explosions/E_Pang2.tscn")
@onready var E_Pang3 = load("res://Effects/Explosions/E_Pang3.tscn")
@onready var E_RocketFlash = load("res://Effects/Explosions/E_RocketFlash.tscn")
@onready var E_Pang_Sparks1 = load("res://Effects/Explosions/E_Pang_Sparks1.tscn")
@onready var E_Pang_Sparks2 = load("res://Effects/Explosions/E_Pang_Sparks2.tscn")
@onready var E_Pang_Sparks3 = load("res://Effects/Explosions/E_Pang_Sparks3.tscn")
@onready var E_Pang_Sparks4 = load("res://Effects/Explosions/E_Pang_Sparks4.tscn")
@onready var E_Fire = load("res://Effects/E_Fire.tscn")
@onready var E_SmokeTrail = load("res://Effects/E_SmokeTrail.tscn")

@onready var Struct_Ice_Asteroid_1 = load("res://Structures/Asteroids/Struct_Ice_Asteroid_1.tscn")
@onready var Struct_Ice_Asteroid_2 = load("res://Structures/Asteroids/Struct_Ice_Asteroid_2.tscn")
@onready var Struct_Ice_Asteroid_3 = load("res://Structures/Asteroids/Struct_Ice_Asteroid_3.tscn")
@onready var Struct_Ice_Asteroid_4 = load("res://Structures/Asteroids/Struct_Ice_Asteroid_4.tscn")
@onready var Struct_Ice_Big_Asteroid_1 = load("res://Structures/Asteroids/Struct_Ice_Big_Asteroid_1.tscn")
@onready var Struct_Ice_Big_Asteroid_2 = load("res://Structures/Asteroids/Struct_Ice_Big_Asteroid_2.tscn")
@onready var Struct_Ice_Big_Asteroid_3 = load("res://Structures/Asteroids/Struct_Ice_Big_Asteroid_3.tscn")
@onready var Struct_Ice_Big_Asteroid_4 = load("res://Structures/Asteroids/Struct_Ice_Big_Asteroid_4.tscn")
@onready var Struct_Lava_Asteroid_1 = load("res://Structures/Asteroids/Struct_Lava_Asteroid_1.tscn")
@onready var Struct_Lava_Asteroid_2 = load("res://Structures/Asteroids/Struct_Lava_Asteroid_2.tscn")
@onready var Struct_Lava_Asteroid_3 = load("res://Structures/Asteroids/Struct_Lava_Asteroid_3.tscn")
@onready var Struct_Lava_Asteroid_4 = load("res://Structures/Asteroids/Struct_Lava_Asteroid_4.tscn")
@onready var Struct_Lava_Big_Asteroid_1 = load("res://Structures/Asteroids/Struct_Lava_Big_Asteroid_1.tscn")
@onready var Struct_Lava_Big_Asteroid_2 = load("res://Structures/Asteroids/Struct_Lava_Big_Asteroid_2.tscn")
@onready var Struct_Lava_Big_Asteroid_3 = load("res://Structures/Asteroids/Struct_Lava_Big_Asteroid_3.tscn")
@onready var Struct_Lava_Big_Asteroid_4 = load("res://Structures/Asteroids/Struct_Lava_Big_Asteroid_4.tscn")
@onready var Struct_Metal_Asteroid_1 = load("res://Structures/Asteroids/Struct_Metal_Asteroid_1.tscn")
@onready var Struct_Metal_Asteroid_2 = load("res://Structures/Asteroids/Struct_Metal_Asteroid_2.tscn")
@onready var Struct_Metal_Asteroid_3 = load("res://Structures/Asteroids/Struct_Metal_Asteroid_3.tscn")
@onready var Struct_Metal_Asteroid_4 = load("res://Structures/Asteroids/Struct_Metal_Asteroid_4.tscn")
@onready var Struct_Metal_Big_Asteroid_1 = load("res://Structures/Asteroids/Struct_Metal_Big_Asteroid_1.tscn")
@onready var Struct_Metal_Big_Asteroid_2 = load("res://Structures/Asteroids/Struct_Metal_Big_Asteroid_2.tscn")
@onready var Struct_Metal_Big_Asteroid_3 = load("res://Structures/Asteroids/Struct_Metal_Big_Asteroid_3.tscn")
@onready var Struct_Metal_Big_Asteroid_4 = load("res://Structures/Asteroids/Struct_Metal_Big_Asteroid_4.tscn")
@onready var Struct_Stony_Asteroid_1 = load("res://Structures/Asteroids/Struct_Stony_Asteroid_1.tscn")
@onready var Struct_Stony_Asteroid_2 = load("res://Structures/Asteroids/Struct_Stony_Asteroid_2.tscn")
@onready var Struct_Stony_Asteroid_3 = load("res://Structures/Asteroids/Struct_Stony_Asteroid_3.tscn")
@onready var Struct_Stony_Asteroid_4 = load("res://Structures/Asteroids/Struct_Stony_Asteroid_4.tscn")
@onready var Struct_Stony_Big_Asteroid_1 = load("res://Structures/Asteroids/Struct_Stony_Big_Asteroid_1.tscn")
@onready var Struct_Stony_Big_Asteroid_2 = load("res://Structures/Asteroids/Struct_Stony_Big_Asteroid_2.tscn")
@onready var Struct_Stony_Big_Asteroid_3 = load("res://Structures/Asteroids/Struct_Stony_Big_Asteroid_3.tscn")
@onready var Struct_Stony_Big_Asteroid_4 = load("res://Structures/Asteroids/Struct_Stony_Big_Asteroid_4.tscn")
@onready var Struct_Chondrite_Asteroid_1 = load("res://Structures/Asteroids/Struct_Chondrite_Asteroid_1.tscn")
@onready var Struct_Chondrite_Asteroid_2 = load("res://Structures/Asteroids/Struct_Chondrite_Asteroid_2.tscn")
@onready var Struct_Chondrite_Asteroid_3 = load("res://Structures/Asteroids/Struct_Chondrite_Asteroid_3.tscn")
@onready var Struct_Chondrite_Asteroid_4 = load("res://Structures/Asteroids/Struct_Chondrite_Asteroid_4.tscn")
@onready var Struct_Chondrite_Big_Asteroid_1 = load("res://Structures/Asteroids/Struct_Chondrite_Big_Asteroid_1.tscn")
@onready var Struct_Chondrite_Big_Asteroid_2 = load("res://Structures/Asteroids/Struct_Chondrite_Big_Asteroid_2.tscn")
@onready var Struct_Chondrite_Big_Asteroid_3 = load("res://Structures/Asteroids/Struct_Chondrite_Big_Asteroid_3.tscn")
@onready var Struct_Chondrite_Big_Asteroid_4 = load("res://Structures/Asteroids/Struct_Chondrite_Big_Asteroid_4.tscn")
@onready var Struct_Rocky_Asteroid_1 = load("res://Structures/Asteroids/Struct_Rocky_Asteroid_1.tscn")
@onready var Struct_Rocky_Asteroid_2 = load("res://Structures/Asteroids/Struct_Rocky_Asteroid_2.tscn")
@onready var Struct_Rocky_Asteroid_3 = load("res://Structures/Asteroids/Struct_Rocky_Asteroid_3.tscn")
@onready var Struct_Rocky_Asteroid_4 = load("res://Structures/Asteroids/Struct_Rocky_Asteroid_4.tscn")
@onready var Struct_Rocky_Big_Asteroid_1 = load("res://Structures/Asteroids/Struct_Rocky_Big_Asteroid_1.tscn")
@onready var Struct_Rocky_Big_Asteroid_2 = load("res://Structures/Asteroids/Struct_Rocky_Big_Asteroid_2.tscn")
@onready var Struct_Rocky_Big_Asteroid_3 = load("res://Structures/Asteroids/Struct_Rocky_Big_Asteroid_3.tscn")
@onready var Struct_Rocky_Big_Asteroid_4 = load("res://Structures/Asteroids/Struct_Rocky_Big_Asteroid_4.tscn")
@onready var Struct_BaseStation_A = load("res://Structures/Struct_BaseStation_A.tscn")
@onready var Struct_BossStation_A = load("res://Structures/Struct_BossStation_A.tscn")
@onready var Struct_Reactor = load("res://Structures/Struct_Reactor.tscn")
@onready var Struct_Extractor = load("res://Structures/Struct_Extractor.tscn")
@onready var Struct_Fighter_Bay = load("res://Structures/Struct_Fighter_Bay.tscn")
@onready var Struct_Corvette_Bay = load("res://Structures/Struct_Corvette_Bay.tscn")
@onready var Struct_Stardock = load("res://Structures/Struct_Stardock.tscn")
@onready var Struct_Destroyer_Dock = load("res://Structures/Struct_Destroyer_Dock.tscn")
@onready var Struct_Starport = load("res://Structures/Struct_Starport.tscn")
@onready var Struct_Blaster_Turret = load("res://Structures/Struct_Blaster_Turret.tscn")
@onready var Struct_Double_Blaster_Turret = load("res://Structures/Struct_Double_Blaster_Turret.tscn")
@onready var Struct_Autogun_Turret = load("res://Structures/Struct_Autogun_Turret.tscn")
@onready var Struct_Autocannon_Turret = load("res://Structures/Struct_Autocannon_Turret.tscn")
@onready var Struct_Artillery_Turret = load("res://Structures/Struct_Artillery_Turret.tscn")
@onready var Struct_Mjolnir_Turret = load("res://Structures/Struct_Mjolnir_Turret.tscn")
@onready var Struct_Laser_Turret = load("res://Structures/Struct_Laser_Turret.tscn")
@onready var Struct_Lasercannon_Turret = load("res://Structures/Struct_Lasercannon_Turret.tscn")
@onready var Struct_Phalanx = load("res://Structures/Struct_Phalanx.tscn")
@onready var Struct_Plasmacaster = load("res://Structures/Struct_Plasmacaster.tscn")
@onready var Struct_Missile_Turret = load("res://Structures/Struct_Missile_Turret.tscn")
@onready var Struct_QuadMissile_Turret = load("res://Structures/Struct_QuadMissile_Turret.tscn")
@onready var Struct_Barricade = load("res://Structures/Struct_Barricade.tscn")
@onready var Struct_Repair_Turret = load("res://Structures/Struct_Repair_Turret.tscn")
@onready var Struct_HyperRepair_Turret = load("res://Structures/Struct_HyperRepair_Turret.tscn")
@onready var Struct_Shield = load("res://Structures/Struct_Shield.tscn")
@onready var Struct_Heavy_Shield = load("res://Structures/Struct_Heavy_Shield.tscn")

@onready var Ship_Piranha = load("res://Ships/Ship_Piranha.tscn")
@onready var Ship_Rapier = load("res://Ships/Ship_Rapier.tscn")
@onready var Ship_Saber = load("res://Ships/Ship_Saber.tscn")
@onready var Ship_Miner = load("res://Ships/Ship_Miner.tscn")
@onready var Ship_Mosquito = load("res://Ships/Ship_Mosquito.tscn")
@onready var Ship_Hawk = load("res://Ships/Ship_Hawk.tscn")
@onready var Ship_Mantis = load("res://Ships/Ship_Mantis.tscn")
@onready var Ship_Fury = load("res://Ships/Ship_Fury.tscn")

@onready var Ship_Builder = load("res://Ships/Ship_Builder.tscn")
@onready var Ship_Puma = load("res://Ships/Ship_Puma.tscn")
@onready var Ship_Falcon = load("res://Ships/Ship_Falcon.tscn")
@onready var Ship_Gladiator = load("res://Ships/Ship_Gladiator.tscn")
@onready var Ship_Knight = load("res://Ships/Ship_Knight.tscn")

@onready var Ship_Spartan = load("res://Ships/Ship_Spartan.tscn")
@onready var Ship_Metalporter = load("res://Ships/Ship_Metalporter.tscn")
@onready var Ship_Grendal = load("res://Ships/Ship_Grendal.tscn")
@onready var Ship_Myrmidon = load("res://Ships/Ship_Myrmidon.tscn")
@onready var Ship_Cobra = load("res://Ships/Ship_Cobra.tscn")
@onready var Ship_Minotaur = load("res://Ships/Ship_Minotaur.tscn")
@onready var Ship_Athena = load("res://Ships/Ship_Athena.tscn")
@onready var Ship_Scorpion = load("res://Ships/Ship_Scorpion.tscn")

@onready var Ship_Trident = load("res://Ships/Ship_Trident.tscn")
@onready var Ship_Goliath = load("res://Ships/Ship_Goliath.tscn")
@onready var Ship_Beam_Halo = load("res://Ships/Ship_Beam_Halo.tscn")
@onready var Ship_Plasma_Halo = load("res://Ships/Ship_Plasma_Halo.tscn")
@onready var Ship_Artillery_Halo = load("res://Ships/Ship_Artillery_Halo.tscn")
@onready var Ship_Hammerhead = load("res://Ships/Ship_Hammerhead.tscn")
@onready var Ship_Cataclysm = load("res://Ships/Ship_Cataclysm.tscn")

@onready var Shot_Blaster = load("res://Shots/Shot_Blaster.tscn")
@onready var Shot_Double_Blaster = load("res://Shots/Shot_Double_Blaster.tscn")
@onready var Explode_Basic = load("res://Shots/Explode_Basic.tscn")
@onready var Explode_Plasma = load("res://Shots/Explode_Plasma.tscn")
var next_spawn_id = 1

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _spawn(s, p, position, velocity, rotation, up, init):
	var obj
	var r = 0.0
	match int(s[0]):
		102:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Ice_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Ice_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Ice_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Ice_Asteroid_4.instantiate()
		103:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Ice_Big_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Ice_Big_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Ice_Big_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Ice_Big_Asteroid_4.instantiate()
		104:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Lava_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Lava_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Lava_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Lava_Asteroid_4.instantiate()
		105:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Lava_Big_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Lava_Big_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Lava_Big_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Lava_Big_Asteroid_4.instantiate()
		106:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Metal_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Metal_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Metal_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Metal_Asteroid_4.instantiate()
		107:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Metal_Big_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Metal_Big_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Metal_Big_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Metal_Big_Asteroid_4.instantiate()
		108:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Stony_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Stony_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Stony_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Stony_Asteroid_4.instantiate()
		109:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Stony_Big_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Stony_Big_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Stony_Big_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Stony_Big_Asteroid_4.instantiate()
		110:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Chondrite_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Chondrite_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Chondrite_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Chondrite_Asteroid_4.instantiate()
		111:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Chondrite_Big_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Chondrite_Big_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Chondrite_Big_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Chondrite_Big_Asteroid_4.instantiate()
		112:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Rocky_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Rocky_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Rocky_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Rocky_Asteroid_4.instantiate()
		113:
			r = float(CALC._rand())
			if(r >= 0 && r < .25):
				obj = Struct_Rocky_Big_Asteroid_1.instantiate()
			if(r >= .25 && r < .5):
				obj = Struct_Rocky_Big_Asteroid_2.instantiate()
			if(r >= .5 && r < .75):
				obj = Struct_Rocky_Big_Asteroid_3.instantiate()
			if(r >= .75 && r <= 1):
				obj = Struct_Rocky_Big_Asteroid_4.instantiate()
		200:
			obj = Struct_BaseStation_A.instantiate()
		230:
			obj = Struct_BossStation_A.instantiate()
		250:
			obj = Struct_Reactor.instantiate()
		251:
			obj = Struct_Extractor.instantiate()
		275:
			obj = Struct_Fighter_Bay.instantiate()
		276:
			obj = Struct_Corvette_Bay.instantiate()
		277:
			obj = Struct_Stardock.instantiate()
		278:
			obj = Struct_Destroyer_Dock.instantiate()
		279:
			obj = Struct_Starport.instantiate()
		300:
			obj = Struct_Blaster_Turret.instantiate()
		301:
			obj = Struct_Double_Blaster_Turret.instantiate()
		302:
			obj = Struct_Autogun_Turret.instantiate()
		303:
			obj = Struct_Phalanx.instantiate()
		304:
			obj = Struct_Artillery_Turret.instantiate()
		305:
			obj = Struct_Laser_Turret.instantiate()
		306:
			obj = Struct_Lasercannon_Turret.instantiate()
		307:
			obj = Struct_Missile_Turret.instantiate()
		308:
			obj = Struct_Repair_Turret.instantiate()
		500:
			obj = Struct_Mjolnir_Turret.instantiate()
		501:
			obj = Struct_Autocannon_Turret.instantiate()
		502:
			obj = Struct_Plasmacaster.instantiate()
		503:
			obj = Struct_QuadMissile_Turret.instantiate()
		504:
			obj = Struct_HyperRepair_Turret.instantiate()
		1000:
			obj = Struct_Barricade.instantiate()
		1001:
			obj = Struct_Shield.instantiate()
		1002:
			obj = Struct_Heavy_Shield.instantiate()
		2000:
			obj = Ship_Piranha.instantiate()
		2001:
			obj = Ship_Rapier.instantiate()
		2002:
			obj = Ship_Saber.instantiate()
		2003:
			obj = Ship_Miner.instantiate()
		2004:
			obj = Ship_Mosquito.instantiate()
		2005:
			obj = Ship_Hawk.instantiate()
		2006:
			obj = Ship_Mantis.instantiate()
		2007:
			obj = Ship_Fury.instantiate()
		2500:
			obj = Ship_Builder.instantiate()
		2501:
			obj = Ship_Puma.instantiate()
		2502:
			obj = Ship_Falcon.instantiate()
		2503:
			obj = Ship_Gladiator.instantiate()
		2504:
			obj = Ship_Knight.instantiate()
		3000:
			obj = Ship_Spartan.instantiate()
		3001:
			obj = Ship_Metalporter.instantiate()
		3002:
			obj = Ship_Grendal.instantiate()
		3003:
			obj = Ship_Myrmidon.instantiate() #Replace
		3004:
			obj = Ship_Cobra.instantiate()
		3005:
			obj = Ship_Minotaur.instantiate()
		3006:
			obj = Ship_Athena.instantiate()
		3007:
			obj = Ship_Scorpion.instantiate()
		3500:
			obj = Ship_Myrmidon.instantiate()
		4000:
			obj = Ship_Trident.instantiate()
		4001:
			obj = Ship_Goliath.instantiate()
		4002:
			obj = Ship_Beam_Halo.instantiate()
		4003:
			obj = Ship_Plasma_Halo.instantiate()
		4004:
			obj = Ship_Artillery_Halo.instantiate()
		4005:
			obj = Ship_Hammerhead.instantiate()
		4006:
			obj = Ship_Cataclysm.instantiate()
		5000:
			obj = Shot_Blaster.instantiate()
		5001:
			obj = Shot_Double_Blaster.instantiate()
		6000:
			obj = Explode_Basic.instantiate()
		6001:
			obj = Explode_Plasma.instantiate()
			obj.pos = position
			#obj._boom()
		10000:
			obj = E_ClickBoom.instantiate()
		10001:
			obj = E_Credits.instantiate()
			if(s[1] > 100):
				s[1] = 100
			obj.get_node("Credit_Particles").amount = s[1]
		10002:
			obj = E_BuildFlash.instantiate()
		10100:
			obj = E_FireworkA.instantiate()
		10101:
			obj = E_FireworkB.instantiate()
		10105:
			obj = E_BigFirework.instantiate()
		10106:
			obj = E_AsteroidBoomT.instantiate()
		10107:
			obj = E_AsteroidBoomS.instantiate()
		10108:
			obj = E_AsteroidBoomL.instantiate()
		10109:
			obj = E_BoomStation.instantiate()
		10110:
			obj = E_BoomSmall.instantiate()
		10111:
			obj = E_SparksM.instantiate()
		10112:
			obj = E_Miner_Flash.instantiate()
		10200:
			obj = E_Impact_Kinetic.instantiate()
		10201:
			obj = E_Impact_Laser.instantiate()
		10202:
			obj = E_Impact_Mining.instantiate()
		10203:
			obj = E_Impact_Phalanx.instantiate()
		10204:
			obj = E_Impact_Repair.instantiate()
		10205:
			obj = E_Impact_Shield.instantiate()
		10300:
			r = randf()
			if(r >= 0 && r < .2):
				obj = E_Boom1.instantiate()
			if(r >= .2 && r < .4):
				obj = E_Boom2.instantiate()
			if(r >= .4 && r < .6):
				obj = E_Boom3.instantiate()
			if(r >= .6 && r < .8):
				obj = E_Boom4.instantiate()
			if(r >= .8 && r <= 1):
				obj = E_Boom5.instantiate()
		10301:
			r = randf()
			if(r >= 0 && r < .2):
				obj = E_BoomPuff1.instantiate()
			if(r >= .2 && r < .4):
				obj = E_BoomPuff2.instantiate()
			if(r >= .4 && r < .6):
				obj = E_BoomPuff3.instantiate()
			if(r >= .6 && r < .8):
				obj = E_BoomPuff4.instantiate()
			if(r >= .8 && r <= 1):
				obj = E_BoomPuff5.instantiate()
		10302:
			r = randf()
			if(r >= 0 && r < .2):
				obj = E_Flare1.instantiate()
			if(r >= .2 && r < .4):
				obj = E_Flare2.instantiate()
			if(r >= .4 && r < .6):
				obj = E_Flare3.instantiate()
			if(r >= .6 && r < .8):
				obj = E_Flare4.instantiate()
			if(r >= .8 && r <= 1):
				obj = E_Flare5.instantiate()
			obj.scale = Vector2(1,1)
			obj.modulate = Color(1,1,1,.1)
		10303:
			obj = E_Flash_Bloom.instantiate()
		10304:
			r = randf()
			if(r >= 0 && r < .2):
				obj = E_Smoke1.instantiate()
			if(r >= .2 && r < .4):
				obj = E_Smoke2.instantiate()
			if(r >= .4 && r < .6):
				obj = E_Smoke3.instantiate()
			if(r >= .6 && r < .8):
				obj = E_Smoke4.instantiate()
			if(r >= .8 && r <= 1):
				obj = E_Smoke5.instantiate()
		10305:
			r = randf()
			if(r >= 0 && r < .33):
				obj = E_PlasmaBoom1.instantiate()
			if(r >= .33 && r < .66):
				obj = E_PlasmaBoom2.instantiate()
			if(r >= .66 && r <= 1):
				obj = E_PlasmaBoom3.instantiate()
		10306:
			obj = E_PlasmaFlash.instantiate()
		10307:
			r = randf()
			if(r >= 0 && r < .33):
				obj = E_Pang1.instantiate()
			if(r >= .33 && r < .66):
				obj = E_Pang2.instantiate()
			if(r >= .66 && r <= 1):
				obj = E_Pang3.instantiate()
		10308:
			obj = E_RocketFlash.instantiate()
		10309:
			r = randf()
			if(r >= 0 && r < .33):
				obj = E_Pang_Sparks1.instantiate()
			if(r >= .25 && r < .5):
				obj = E_Pang_Sparks2.instantiate()
			if(r >= .5 && r < .75):
				obj = E_Pang_Sparks3.instantiate()
			if(r >= .75 && r <= 1):
				obj = E_Pang_Sparks4.instantiate()
		10310:
			obj = E_Fire.instantiate()
			obj.scale = Vector2(.3,.3)
		10311:
			obj = E_SmokeTrail.instantiate()
			#obj.scale = Vector2(.3,.3)
	obj.s = s
	if(up == 0):
		game._super_add_child(obj)
		obj.spawn_id = next_spawn_id
		next_spawn_id = next_spawn_id + 1
		obj.pos = position
	if(up == 10):
		solarsystem.add_child(obj)
	if(up == 11):
		results.add_child(obj)
	if(up == 12):
		build_button.add_child(obj)
	if(up == 13):
		pass
	if(up == 14):
		gui.add_child(obj)
	obj.velocity = velocity
	obj.position = position
	obj.pos = position
	obj.rotation = rotation
	obj.rotate = rotation
	if(s[0] < 10000):
		if(obj.is_type == "STRUCT"):
			obj._build_fix()
		if(obj.is_type == "SHIP"):
			obj._ship_fix()
		#Bug Here
		if(p != null && game.players.size() > p):
			obj._set_player(game.players[p])
	return obj

func _spawn_dupe(s, p, position, velocity, rotation, up, init):
	var obj
	obj = s.duplicate()
	if(up == 0):
		game._super_add_child(obj)
		obj.spawn_id = next_spawn_id
		next_spawn_id = next_spawn_id + 1
	obj.velocity = velocity
	obj.position = position
	obj.pos = position
	obj.rotation = rotation
	obj.rotate = rotation
	if(obj.is_type == "STRUCT"):
		obj._build_fix()
	if(obj.is_type == "SHIP"):
		obj.rotation = 0
	if(p != null && game.players.size() > p):
		if(obj.has_method("_set_player")):
			obj._set_player(game.players[p])
	return obj

func _spawn_laser(s, p, pa, pb):
	var obj
	var r = 0
	var theta = 0
	obj = s.duplicate()
	game._super_add_child(obj)
	obj.spawn_id = next_spawn_id
	next_spawn_id = next_spawn_id + 1
	obj._ignite(pa,pb)
	if(p != null && game.players.size() > p):
		if(obj.has_method("_set_player")):
			obj._set_player(game.players[p])
	return obj

func _spawn_hit(s, damage, position, velocity, rotation):
	var obj
	match s:
		"KINETIC":
			obj = _spawn([10200], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(float(sqrt(damage)) / 4, float(sqrt(damage)) / 4)
		"EXPLOSIVE":
			obj = _spawn([6000], null, position, velocity, rotation, 0, 0)
		"LASER":
			obj = _spawn([10201], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(float(sqrt(damage)) / 4, float(sqrt(damage)) / 4)
		"MINING":
			obj = _spawn([10202], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(1.2,1.2)
			obj = _spawn([10304], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(.3,.3)
			obj.modulate = Color(3,3,3,.6)
		"PHALANX":
			obj = _spawn([10203], null, position, Vector2(0,0), rotation, 0, 0)
		"REPAIR":
			obj = _spawn([10204], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(float(sqrt(abs(damage))) / 4, float(sqrt(abs(damage))) / 4)
		"PLASMA":
			obj = _spawn([6001], null, position, velocity, rotation, 0, 0)
			#obj = _spawn([10305], null, position, Vector2(0,0), rotation, 0, 0)
			#obj.scale = Vector2(2,2)
			#obj = _spawn([10306], null, position, Vector2(0,0), rotation, 0, 0)
		"SPARTAN":
			obj = _spawn([6000], null, position, velocity, rotation, 0, 0)
			obj.boom_scale = .7
		"SHIELD":
			obj = _spawn([10205], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(float(sqrt(damage)) / 3, float(sqrt(damage)) / 3)
	
func _spawn_player(faction,variant):
	var p = Player.new()
	p._set_faction(faction,variant)
	p.id = game.players.size()
	game.players.append(p)

func _spawn_stats():
	var obj
	obj = Stats.instantiate()
	game._super_add_child(obj)
	return obj
