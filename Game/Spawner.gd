extends Node

@onready var game
@onready var solarsystem
@onready var results
@onready var build_button
@onready var gui

@onready var Player := load("res://Player.gd")

@onready var Stats := load("res://Game/Stats/Stats.tscn")

@onready var E_ClickBoom := load("res://Effects/E_ClickBoom.tscn")
@onready var E_FireworkA := load("res://Effects/E_FireworkA.tscn")
@onready var E_FireworkB := load("res://Effects/E_FireworkB.tscn")
@onready var E_BigFirework := load("res://Effects/E_BigFirework.tscn")
@onready var E_AsteroidBoomT := load("res://Effects/E_AsteroidBoomT.tscn")
@onready var E_AsteroidBoomS := load("res://Effects/E_AsteroidBoomS.tscn")
@onready var E_AsteroidBoomL := load("res://Effects/E_AsteroidBoomL.tscn")
@onready var E_BoomStation := load("res://Effects/E_BoomStation.tscn")
@onready var E_BoomSmall := load("res://Effects/E_BoomSmall.tscn")
@onready var E_SparksM := load("res://Effects/E_SparksM.tscn")
@onready var E_Miner_Flash := load("res://Effects/E_Miner_Flash.tscn")
@onready var E_Impact_Kinetic := load("res://Effects/E_Impact_Kinetic.tscn")
@onready var E_Impact_Laser := load("res://Effects/E_Impact_Laser.tscn")
@onready var E_Impact_Mining := load("res://Effects/E_Impact_Mining.tscn")
@onready var E_Impact_Phalanx := load("res://Effects/E_Impact_Phalanx.tscn")
@onready var E_Impact_Repair := load("res://Effects/E_Impact_Repair.tscn")
@onready var E_Impact_Shield := load("res://Effects/E_Impact_Shield.tscn")
@onready var E_Boom1 := load("res://Effects/Explosions/E_Boom1.tscn")
@onready var E_Boom2 := load("res://Effects/Explosions/E_Boom2.tscn")
@onready var E_Boom3 := load("res://Effects/Explosions/E_Boom3.tscn")
@onready var E_Boom4 := load("res://Effects/Explosions/E_Boom4.tscn")
@onready var E_Boom5 := load("res://Effects/Explosions/E_Boom5.tscn")
@onready var E_BoomPuff1 := load("res://Effects/Explosions/E_BoomPuff1.tscn")
@onready var E_BoomPuff2 := load("res://Effects/Explosions/E_BoomPuff2.tscn")
@onready var E_BoomPuff3 := load("res://Effects/Explosions/E_BoomPuff3.tscn")
@onready var E_BoomPuff4 := load("res://Effects/Explosions/E_BoomPuff4.tscn")
@onready var E_BoomPuff5 := load("res://Effects/Explosions/E_BoomPuff5.tscn")
@onready var E_Flare1 := load("res://Effects/Explosions/E_Flare1.tscn")
@onready var E_Flare2 := load("res://Effects/Explosions/E_Flare2.tscn")
@onready var E_Flare3 := load("res://Effects/Explosions/E_Flare3.tscn")
@onready var E_Flare4 := load("res://Effects/Explosions/E_Flare4.tscn")
@onready var E_Flare5 := load("res://Effects/Explosions/E_Flare5.tscn")
@onready var E_Smoke1 := load("res://Effects/Explosions/E_Smoke1.tscn")
@onready var E_Smoke2 := load("res://Effects/Explosions/E_Smoke2.tscn")
@onready var E_Smoke3 := load("res://Effects/Explosions/E_Smoke3.tscn")
@onready var E_Smoke4 := load("res://Effects/Explosions/E_Smoke4.tscn")
@onready var E_Smoke5 := load("res://Effects/Explosions/E_Smoke5.tscn")
@onready var E_PlasmaBoom1 := load("res://Effects/Explosions/E_PlasmaBoom1.tscn")
@onready var E_PlasmaBoom2 := load("res://Effects/Explosions/E_PlasmaBoom2.tscn")
@onready var E_PlasmaBoom3 := load("res://Effects/Explosions/E_PlasmaBoom3.tscn")
@onready var E_Flash_Bloom := load("res://Effects/Explosions/E_Flash_Bloom.tscn")
@onready var E_Credits := load("res://Effects/E_Credits.tscn")
@onready var E_BuildFlash := load("res://Effects/E_BuildFlash.tscn")
@onready var E_PlasmaFlash := load("res://Effects/Explosions/E_PlasmaFlash.tscn")
@onready var E_Pang1 := load("res://Effects/Explosions/E_Pang1.tscn")
@onready var E_Pang2 := load("res://Effects/Explosions/E_Pang2.tscn")
@onready var E_Pang3 := load("res://Effects/Explosions/E_Pang3.tscn")
@onready var E_RocketFlash := load("res://Effects/Explosions/E_RocketFlash.tscn")
@onready var E_Pang_Sparks1 := load("res://Effects/Explosions/E_Pang_Sparks1.tscn")
@onready var E_Pang_Sparks2 := load("res://Effects/Explosions/E_Pang_Sparks2.tscn")
@onready var E_Pang_Sparks3 := load("res://Effects/Explosions/E_Pang_Sparks3.tscn")
@onready var E_Pang_Sparks4 := load("res://Effects/Explosions/E_Pang_Sparks4.tscn")
@onready var E_Fire := load("res://Effects/E_Fire.tscn")
@onready var E_SmokeTrail := load("res://Effects/E_SmokeTrail.tscn")

@onready var Struct_Ice_Asteroid_1 := load("res://Structures/Asteroids/Struct_Ice_Asteroid_1.tscn")
@onready var Struct_Ice_Asteroid_2 := load("res://Structures/Asteroids/Struct_Ice_Asteroid_2.tscn")
@onready var Struct_Ice_Asteroid_3 := load("res://Structures/Asteroids/Struct_Ice_Asteroid_3.tscn")
@onready var Struct_Ice_Asteroid_4 := load("res://Structures/Asteroids/Struct_Ice_Asteroid_4.tscn")
@onready var Struct_Ice_Big_Asteroid_1 := load("res://Structures/Asteroids/Struct_Ice_Big_Asteroid_1.tscn")
@onready var Struct_Ice_Big_Asteroid_2 := load("res://Structures/Asteroids/Struct_Ice_Big_Asteroid_2.tscn")
@onready var Struct_Ice_Big_Asteroid_3 := load("res://Structures/Asteroids/Struct_Ice_Big_Asteroid_3.tscn")
@onready var Struct_Ice_Big_Asteroid_4 := load("res://Structures/Asteroids/Struct_Ice_Big_Asteroid_4.tscn")
@onready var Struct_Lava_Asteroid_1 := load("res://Structures/Asteroids/Struct_Lava_Asteroid_1.tscn")
@onready var Struct_Lava_Asteroid_2 := load("res://Structures/Asteroids/Struct_Lava_Asteroid_2.tscn")
@onready var Struct_Lava_Asteroid_3 := load("res://Structures/Asteroids/Struct_Lava_Asteroid_3.tscn")
@onready var Struct_Lava_Asteroid_4 := load("res://Structures/Asteroids/Struct_Lava_Asteroid_4.tscn")
@onready var Struct_Lava_Big_Asteroid_1 := load("res://Structures/Asteroids/Struct_Lava_Big_Asteroid_1.tscn")
@onready var Struct_Lava_Big_Asteroid_2 := load("res://Structures/Asteroids/Struct_Lava_Big_Asteroid_2.tscn")
@onready var Struct_Lava_Big_Asteroid_3 := load("res://Structures/Asteroids/Struct_Lava_Big_Asteroid_3.tscn")
@onready var Struct_Lava_Big_Asteroid_4 := load("res://Structures/Asteroids/Struct_Lava_Big_Asteroid_4.tscn")
@onready var Struct_Metal_Asteroid_1 := load("res://Structures/Asteroids/Struct_Metal_Asteroid_1.tscn")
@onready var Struct_Metal_Asteroid_2 := load("res://Structures/Asteroids/Struct_Metal_Asteroid_2.tscn")
@onready var Struct_Metal_Asteroid_3 := load("res://Structures/Asteroids/Struct_Metal_Asteroid_3.tscn")
@onready var Struct_Metal_Asteroid_4 := load("res://Structures/Asteroids/Struct_Metal_Asteroid_4.tscn")
@onready var Struct_Metal_Big_Asteroid_1 := load("res://Structures/Asteroids/Struct_Metal_Big_Asteroid_1.tscn")
@onready var Struct_Metal_Big_Asteroid_2 := load("res://Structures/Asteroids/Struct_Metal_Big_Asteroid_2.tscn")
@onready var Struct_Metal_Big_Asteroid_3 := load("res://Structures/Asteroids/Struct_Metal_Big_Asteroid_3.tscn")
@onready var Struct_Metal_Big_Asteroid_4 := load("res://Structures/Asteroids/Struct_Metal_Big_Asteroid_4.tscn")
@onready var Struct_Stony_Asteroid_1 := load("res://Structures/Asteroids/Struct_Stony_Asteroid_1.tscn")
@onready var Struct_Stony_Asteroid_2 := load("res://Structures/Asteroids/Struct_Stony_Asteroid_2.tscn")
@onready var Struct_Stony_Asteroid_3 := load("res://Structures/Asteroids/Struct_Stony_Asteroid_3.tscn")
@onready var Struct_Stony_Asteroid_4 := load("res://Structures/Asteroids/Struct_Stony_Asteroid_4.tscn")
@onready var Struct_Stony_Big_Asteroid_1 := load("res://Structures/Asteroids/Struct_Stony_Big_Asteroid_1.tscn")
@onready var Struct_Stony_Big_Asteroid_2 := load("res://Structures/Asteroids/Struct_Stony_Big_Asteroid_2.tscn")
@onready var Struct_Stony_Big_Asteroid_3 := load("res://Structures/Asteroids/Struct_Stony_Big_Asteroid_3.tscn")
@onready var Struct_Stony_Big_Asteroid_4 := load("res://Structures/Asteroids/Struct_Stony_Big_Asteroid_4.tscn")
@onready var Struct_Chondrite_Asteroid_1 := load("res://Structures/Asteroids/Struct_Chondrite_Asteroid_1.tscn")
@onready var Struct_Chondrite_Asteroid_2 := load("res://Structures/Asteroids/Struct_Chondrite_Asteroid_2.tscn")
@onready var Struct_Chondrite_Asteroid_3 := load("res://Structures/Asteroids/Struct_Chondrite_Asteroid_3.tscn")
@onready var Struct_Chondrite_Asteroid_4 := load("res://Structures/Asteroids/Struct_Chondrite_Asteroid_4.tscn")
@onready var Struct_Chondrite_Big_Asteroid_1 := load("res://Structures/Asteroids/Struct_Chondrite_Big_Asteroid_1.tscn")
@onready var Struct_Chondrite_Big_Asteroid_2 := load("res://Structures/Asteroids/Struct_Chondrite_Big_Asteroid_2.tscn")
@onready var Struct_Chondrite_Big_Asteroid_3 := load("res://Structures/Asteroids/Struct_Chondrite_Big_Asteroid_3.tscn")
@onready var Struct_Chondrite_Big_Asteroid_4 := load("res://Structures/Asteroids/Struct_Chondrite_Big_Asteroid_4.tscn")
@onready var Struct_Rocky_Asteroid_1 := load("res://Structures/Asteroids/Struct_Rocky_Asteroid_1.tscn")
@onready var Struct_Rocky_Asteroid_2 := load("res://Structures/Asteroids/Struct_Rocky_Asteroid_2.tscn")
@onready var Struct_Rocky_Asteroid_3 := load("res://Structures/Asteroids/Struct_Rocky_Asteroid_3.tscn")
@onready var Struct_Rocky_Asteroid_4 := load("res://Structures/Asteroids/Struct_Rocky_Asteroid_4.tscn")
@onready var Struct_Rocky_Big_Asteroid_1 := load("res://Structures/Asteroids/Struct_Rocky_Big_Asteroid_1.tscn")
@onready var Struct_Rocky_Big_Asteroid_2 := load("res://Structures/Asteroids/Struct_Rocky_Big_Asteroid_2.tscn")
@onready var Struct_Rocky_Big_Asteroid_3 := load("res://Structures/Asteroids/Struct_Rocky_Big_Asteroid_3.tscn")
@onready var Struct_Rocky_Big_Asteroid_4 := load("res://Structures/Asteroids/Struct_Rocky_Big_Asteroid_4.tscn")
@onready var Struct_BaseStation_A := load("res://Structures/Struct_BaseStation_A.tscn")
@onready var Struct_BossStation_A := load("res://Structures/Struct_BossStation_A.tscn")
@onready var Struct_Reactor := load("res://Structures/Struct_Reactor.tscn")
@onready var Struct_Extractor := load("res://Structures/Struct_Extractor.tscn")
@onready var Struct_Fighter_Bay := load("res://Structures/Struct_Fighter_Bay.tscn")
@onready var Struct_Corvette_Bay := load("res://Structures/Struct_Corvette_Bay.tscn")
@onready var Struct_Stardock := load("res://Structures/Struct_Stardock.tscn")
@onready var Struct_Destroyer_Dock := load("res://Structures/Struct_Destroyer_Dock.tscn")
@onready var Struct_Starport := load("res://Structures/Struct_Starport.tscn")
@onready var Struct_Blaster_Turret := load("res://Structures/Struct_Blaster_Turret.tscn")
@onready var Struct_Double_Blaster_Turret := load("res://Structures/Struct_Double_Blaster_Turret.tscn")
@onready var Struct_Autogun_Turret := load("res://Structures/Struct_Autogun_Turret.tscn")
@onready var Struct_Autocannon_Turret := load("res://Structures/Struct_Autocannon_Turret.tscn")
@onready var Struct_Artillery_Turret := load("res://Structures/Struct_Artillery_Turret.tscn")
@onready var Struct_Mjolnir_Turret := load("res://Structures/Struct_Mjolnir_Turret.tscn")
@onready var Struct_Laser_Turret := load("res://Structures/Struct_Laser_Turret.tscn")
@onready var Struct_Lasercannon_Turret := load("res://Structures/Struct_Lasercannon_Turret.tscn")
@onready var Struct_Phalanx := load("res://Structures/Struct_Phalanx.tscn")
@onready var Struct_Plasmacaster := load("res://Structures/Struct_Plasmacaster.tscn")
@onready var Struct_Missile_Turret := load("res://Structures/Struct_Missile_Turret.tscn")
@onready var Struct_QuadMissile_Turret := load("res://Structures/Struct_QuadMissile_Turret.tscn")
@onready var Struct_Barricade := load("res://Structures/Struct_Barricade.tscn")
@onready var Struct_Repair_Turret := load("res://Structures/Struct_Repair_Turret.tscn")
@onready var Struct_HyperRepair_Turret := load("res://Structures/Struct_HyperRepair_Turret.tscn")
@onready var Struct_Shield := load("res://Structures/Struct_Shield.tscn")
@onready var Struct_Heavy_Shield := load("res://Structures/Struct_Heavy_Shield.tscn")

@onready var Ship_Piranha := load("res://Ships/Ship_Piranha.tscn")
@onready var Ship_Rapier := load("res://Ships/Ship_Rapier.tscn")
@onready var Ship_Saber := load("res://Ships/Ship_Saber.tscn")
@onready var Ship_Miner := load("res://Ships/Ship_Miner.tscn")
@onready var Ship_Mosquito := load("res://Ships/Ship_Mosquito.tscn")
@onready var Ship_Hawk := load("res://Ships/Ship_Hawk.tscn")
@onready var Ship_Mantis := load("res://Ships/Ship_Mantis.tscn")
@onready var Ship_Fury := load("res://Ships/Ship_Fury.tscn")

@onready var Ship_Builder := load("res://Ships/Ship_Builder.tscn")
@onready var Ship_Puma := load("res://Ships/Ship_Puma.tscn")
@onready var Ship_Falcon := load("res://Ships/Ship_Falcon.tscn")
@onready var Ship_Gladiator := load("res://Ships/Ship_Gladiator.tscn")
@onready var Ship_Knight := load("res://Ships/Ship_Knight.tscn")

@onready var Ship_Spartan := load("res://Ships/Ship_Spartan.tscn")
@onready var Ship_Metalporter := load("res://Ships/Ship_Metalporter.tscn")
@onready var Ship_Grendal := load("res://Ships/Ship_Grendal.tscn")
@onready var Ship_Myrmidon := load("res://Ships/Ship_Myrmidon.tscn")
@onready var Ship_Cobra := load("res://Ships/Ship_Cobra.tscn")
@onready var Ship_Minotaur := load("res://Ships/Ship_Minotaur.tscn")
@onready var Ship_Athena := load("res://Ships/Ship_Athena.tscn")
@onready var Ship_Scorpion := load("res://Ships/Ship_Scorpion.tscn")

@onready var Ship_Trident := load("res://Ships/Ship_Trident.tscn")
@onready var Ship_Goliath := load("res://Ships/Ship_Goliath.tscn")
@onready var Ship_Beam_Halo := load("res://Ships/Ship_Beam_Halo.tscn")
@onready var Ship_Plasma_Halo := load("res://Ships/Ship_Plasma_Halo.tscn")
@onready var Ship_Artillery_Halo := load("res://Ships/Ship_Artillery_Halo.tscn")
@onready var Ship_Hammerhead := load("res://Ships/Ship_Hammerhead.tscn")
@onready var Ship_Cataclysm := load("res://Ships/Ship_Cataclysm.tscn")
@onready var Ship_Legion := load("res://Ships/Ship_Legion.tscn")

@onready var Shot_Blaster = load("res://Shots/Shot_Blaster.tscn")
@onready var Shot_Double_Blaster = load("res://Shots/Shot_Double_Blaster.tscn")
@onready var Explode_Basic = load("res://Shots/Explode_Basic.tscn")
@onready var Explode_Plasma = load("res://Shots/Explode_Plasma.tscn")

enum spawn_objs {

	####### Asteroids #######
	ICE_ASTEROID,
	BIG_ICE_ASTEROID,
	LAVA_ASTEROID,
	BIG_LAVA_ASTEROID,
	METAL_ASTEROID,
	BIG_METAL_ASTEROID,
	STONY_ASTEROID,
	BIG_STONY_ASTEROID,
	CHONDRITE_ASTEROID,
	BIG_CHONDRITE_ASTEROID,
	ROCKY_ASTEROID,
	BIG_ROCKY_ASTEROID,

	####### Human Structs #######
	STATION,
	BOSS_STATION,
	REACTOR,
	EXTRACTOR,
	FIGHTER_BAY,
	CORVETTE_BAY,
	STARDOCK,
	DESTROYER_DOCK,
	STARPORT,
	BLASTER_TURRET,
	DOUBLE_BLASTER,
	AUTOGUN,
	PHALANX,
	ARTILLERY,
	LASER_TURRET,
	LASERCANNON,
	MISSILE_TURRET,
	REPAIR_TURRET,
	MJOLNIR,
	AUTOCANNON,
	PLASMACASTER,
	QUAD_MISSILE,
	HYPER_REPAIR_TURRET,
	BARRICADE,
	SHIELD_AUXILIARY,
	HEAVY_SHIELD,

	####### Human Ships #######
	PIRANHA,
	RAPIER,
	SABER,
	MINER,
	MOSQUITO,
	HAWK,
	MANTIS,
	FURY,
	BUILDER,
	PUMA,
	FALCON,
	GLADIATOR,
	KNIGHT,
	SPARTAN,
	METAL_PORTER,
	GRENDAL,
	MYRMIDON,
	COBRA,
	MINOTAUR,
	ATHENA,
	SCORPION,
	TRIDENT,
	GOLIATH,
	BEAM_HALO,
	ARTILLERY_HALO,
	PLASMA_HALO,
	HAMMERHEAD,
	CATACLYSM,

	####### HAZARDS #######
	SHOT_BLASTER,
	SHOT_DOUBLE_BLASTER,
	EXPLODE_BASIC,
	EXPLODE_PLASMA,

	####### EFFECTS #######
	EFFECT_CLICK_BOOM,
	EFFECT_CREDITS,
	EFFECT_BUILD_FLASH,
	EFFECT_FIREWORK_A,
	EFFECT_FIREWORK_B,
	EFFECT_BIG_FIREWORK,
	EFFECT_ASTEROID_BOOM_TINY,
	EFFECT_ASTEROID_BOOM_SMALL,
	EFFECT_ASTEORID_BOOM_LARGE,
	EFFECT_BOOM_STATION,
	EFFECT_BOOM_SMALL,
	EFFECT_SPARKS_MEDIUM,
	EFFECT_MINER_FLASH,
	EFFECT_IMPACT_KINETIC,
	EFFECT_IMPACT_LASER,
	EFFECT_IMPACT_MINING,
	EFFECT_IMPACT_PHALANX,
	EFFECT_IMPACT_REPAIR,
	EFFECT_IMPACT_SHIELD,
	EFFECT_BOOM,
	EFFECT_BOOM_PUFF,
	EFFECT_FLARE,
	EFFECT_FLASH_BOOM,
	EFFECT_SMOKE,
	EFFECT_PLASMA_BOOM,
	EFFECT_PLASMA_FLASH,
	EFFECT_PANG,
	EFFECT_ROCKET_FLASH,
	EFFECT_PANG_SPARKS,
	EFFECT_FIRE,
	EFFECT_SMOKE_TRAIL,

	#new added stuff

	LEGION
}

var next_spawn_id:int = 1

func _spawn(s, p, position:Vector2, velocity:Vector2, rotation:float, up, init) -> Node2D:
	var obj
	var r := 0.0
	match s[0]:
		spawn_objs.ICE_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Ice_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Ice_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Ice_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Ice_Asteroid_4.instantiate()
		spawn_objs.BIG_ICE_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Ice_Big_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Ice_Big_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Ice_Big_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Ice_Big_Asteroid_4.instantiate()
		spawn_objs.LAVA_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Lava_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Lava_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Lava_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Lava_Asteroid_4.instantiate()
		spawn_objs.BIG_LAVA_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Lava_Big_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Lava_Big_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Lava_Big_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Lava_Big_Asteroid_4.instantiate()
		spawn_objs.METAL_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Metal_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Metal_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Metal_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Metal_Asteroid_4.instantiate()
		spawn_objs.BIG_METAL_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Metal_Big_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Metal_Big_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Metal_Big_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Metal_Big_Asteroid_4.instantiate()
		spawn_objs.STONY_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Stony_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Stony_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Stony_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Stony_Asteroid_4.instantiate()
		spawn_objs.BIG_STONY_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Stony_Big_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Stony_Big_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Stony_Big_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Stony_Big_Asteroid_4.instantiate()
		spawn_objs.CHONDRITE_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Chondrite_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Chondrite_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Chondrite_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Chondrite_Asteroid_4.instantiate()
		spawn_objs.BIG_CHONDRITE_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Chondrite_Big_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Chondrite_Big_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Chondrite_Big_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Chondrite_Big_Asteroid_4.instantiate()
		spawn_objs.ROCKY_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Rocky_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Rocky_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Rocky_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Rocky_Asteroid_4.instantiate()
		spawn_objs.BIG_ROCKY_ASTEROID:
			r = CALC._rand()
			if r >= 0 && r < .25:
				obj = Struct_Rocky_Big_Asteroid_1.instantiate()
			if r >= .25 && r < .5:
				obj = Struct_Rocky_Big_Asteroid_2.instantiate()
			if r >= .5 && r < .75:
				obj = Struct_Rocky_Big_Asteroid_3.instantiate()
			if r >= .75 && r <= 1:
				obj = Struct_Rocky_Big_Asteroid_4.instantiate()
		spawn_objs.STATION:
			obj = Struct_BaseStation_A.instantiate()
		spawn_objs.BOSS_STATION:
			obj = Struct_BossStation_A.instantiate()
		spawn_objs.REACTOR:
			obj = Struct_Reactor.instantiate()
		spawn_objs.EXTRACTOR:
			obj = Struct_Extractor.instantiate()
		spawn_objs.FIGHTER_BAY:
			obj = Struct_Fighter_Bay.instantiate()
		spawn_objs.CORVETTE_BAY:
			obj = Struct_Corvette_Bay.instantiate()
		spawn_objs.STARDOCK:
			obj = Struct_Stardock.instantiate()
		spawn_objs.DESTROYER_DOCK:
			obj = Struct_Destroyer_Dock.instantiate()
		spawn_objs.STARPORT:
			obj = Struct_Starport.instantiate()
		spawn_objs.BLASTER_TURRET:
			obj = Struct_Blaster_Turret.instantiate()
		spawn_objs.DOUBLE_BLASTER:
			obj = Struct_Double_Blaster_Turret.instantiate()
		spawn_objs.AUTOGUN:
			obj = Struct_Autogun_Turret.instantiate()
		spawn_objs.PHALANX:
			obj = Struct_Phalanx.instantiate()
		spawn_objs.ARTILLERY:
			obj = Struct_Artillery_Turret.instantiate()
		spawn_objs.LASER_TURRET:
			obj = Struct_Laser_Turret.instantiate()
		spawn_objs.LASERCANNON:
			obj = Struct_Lasercannon_Turret.instantiate()
		spawn_objs.MISSILE_TURRET:
			obj = Struct_Missile_Turret.instantiate()
		spawn_objs.REPAIR_TURRET:
			obj = Struct_Repair_Turret.instantiate()
		spawn_objs.MJOLNIR:
			obj = Struct_Mjolnir_Turret.instantiate()
		spawn_objs.AUTOCANNON:
			obj = Struct_Autocannon_Turret.instantiate()
		spawn_objs.PLASMACASTER:
			obj = Struct_Plasmacaster.instantiate()
		spawn_objs.QUAD_MISSILE:
			obj = Struct_QuadMissile_Turret.instantiate()
		spawn_objs.HYPER_REPAIR_TURRET:
			obj = Struct_HyperRepair_Turret.instantiate()
		spawn_objs.BARRICADE:
			obj = Struct_Barricade.instantiate()
		spawn_objs.SHIELD_AUXILIARY:
			obj = Struct_Shield.instantiate()
		spawn_objs.HEAVY_SHIELD:
			obj = Struct_Heavy_Shield.instantiate()
		spawn_objs.PIRANHA:
			obj = Ship_Piranha.instantiate()
		spawn_objs.RAPIER:
			obj = Ship_Rapier.instantiate()
		spawn_objs.SABER:
			obj = Ship_Saber.instantiate()
		spawn_objs.MINER:
			obj = Ship_Miner.instantiate()
		spawn_objs.MOSQUITO:
			obj = Ship_Mosquito.instantiate()
		spawn_objs.HAWK:
			obj = Ship_Hawk.instantiate()
		spawn_objs.MANTIS:
			obj = Ship_Mantis.instantiate()
		spawn_objs.FURY:
			obj = Ship_Fury.instantiate()
		spawn_objs.BUILDER:
			obj = Ship_Builder.instantiate()
		spawn_objs.PUMA:
			obj = Ship_Puma.instantiate()
		spawn_objs.FALCON:
			obj = Ship_Falcon.instantiate()
		spawn_objs.GLADIATOR:
			obj = Ship_Gladiator.instantiate()
		spawn_objs.KNIGHT:
			obj = Ship_Knight.instantiate()
		spawn_objs.SPARTAN:
			obj = Ship_Spartan.instantiate()
		spawn_objs.METAL_PORTER:
			obj = Ship_Metalporter.instantiate()
		spawn_objs.GRENDAL:
			obj = Ship_Grendal.instantiate()
		spawn_objs.COBRA:
			obj = Ship_Cobra.instantiate()
		spawn_objs.MINOTAUR:
			obj = Ship_Minotaur.instantiate()
		spawn_objs.ATHENA:
			obj = Ship_Athena.instantiate()
		spawn_objs.SCORPION:
			obj = Ship_Scorpion.instantiate()
		spawn_objs.MYRMIDON:
			obj = Ship_Myrmidon.instantiate()
		spawn_objs.TRIDENT:
			obj = Ship_Trident.instantiate()
		spawn_objs.GOLIATH:
			obj = Ship_Goliath.instantiate()
		spawn_objs.BEAM_HALO:
			obj = Ship_Beam_Halo.instantiate()
		spawn_objs.PLASMA_HALO:
			obj = Ship_Plasma_Halo.instantiate()
		spawn_objs.ARTILLERY_HALO:
			obj = Ship_Artillery_Halo.instantiate()
		spawn_objs.HAMMERHEAD:
			obj = Ship_Hammerhead.instantiate()
		spawn_objs.CATACLYSM:
			obj = Ship_Cataclysm.instantiate()
		spawn_objs.SHOT_BLASTER:
			obj = Shot_Blaster.instantiate()
		spawn_objs.SHOT_DOUBLE_BLASTER:
			obj = Shot_Double_Blaster.instantiate()
		spawn_objs.EXPLODE_BASIC:
			obj = Explode_Basic.instantiate()
		spawn_objs.EXPLODE_PLASMA:
			obj = Explode_Plasma.instantiate()
			obj.pos = position
			#obj._boom()
		spawn_objs.EFFECT_CLICK_BOOM:
			obj = E_ClickBoom.instantiate()
		spawn_objs.EFFECT_CREDITS:
			obj = E_Credits.instantiate()
			if s[1] > 100: s[1] = 100
			obj.get_node("Credit_Particles").amount = s[1]
		spawn_objs.EFFECT_BUILD_FLASH:
			obj = E_BuildFlash.instantiate()
		spawn_objs.EFFECT_FIREWORK_A:
			obj = E_FireworkA.instantiate()
		spawn_objs.EFFECT_FIREWORK_B:
			obj = E_FireworkB.instantiate()
		spawn_objs.EFFECT_BIG_FIREWORK:
			obj = E_BigFirework.instantiate()
		spawn_objs.EFFECT_ASTEROID_BOOM_TINY:
			obj = E_AsteroidBoomT.instantiate()
		spawn_objs.EFFECT_ASTEROID_BOOM_SMALL:
			obj = E_AsteroidBoomS.instantiate()
		spawn_objs.EFFECT_ASTEORID_BOOM_LARGE:
			obj = E_AsteroidBoomL.instantiate()
		spawn_objs.EFFECT_BOOM_STATION:
			obj = E_BoomStation.instantiate()
		spawn_objs.EFFECT_BOOM_SMALL:
			obj = E_BoomSmall.instantiate()
		spawn_objs.EFFECT_SPARKS_MEDIUM:
			obj = E_SparksM.instantiate()
		spawn_objs.EFFECT_MINER_FLASH:
			obj = E_Miner_Flash.instantiate()
		spawn_objs.EFFECT_IMPACT_KINETIC:
			obj = E_Impact_Kinetic.instantiate()
		spawn_objs.EFFECT_IMPACT_LASER:
			obj = E_Impact_Laser.instantiate()
		spawn_objs.EFFECT_IMPACT_MINING:
			obj = E_Impact_Mining.instantiate()
		spawn_objs.EFFECT_IMPACT_PHALANX:
			obj = E_Impact_Phalanx.instantiate()
		spawn_objs.EFFECT_IMPACT_REPAIR:
			obj = E_Impact_Repair.instantiate()
		spawn_objs.EFFECT_IMPACT_SHIELD:
			obj = E_Impact_Shield.instantiate()
		spawn_objs.EFFECT_BOOM:
			r = randf()
			if r >= 0 && r < .2:
				obj = E_Boom1.instantiate()
			if r >= .2 && r < .4:
				obj = E_Boom2.instantiate()
			if r >= .4 && r < .6:
				obj = E_Boom3.instantiate()
			if r >= .6 && r < .8:
				obj = E_Boom4.instantiate()
			if r >= .8 && r <= 1:
				obj = E_Boom5.instantiate()
		spawn_objs.EFFECT_BOOM_PUFF:
			r = randf()
			if r >= 0 && r < .2:
				obj = E_BoomPuff1.instantiate()
			if r >= .2 && r < .4:
				obj = E_BoomPuff2.instantiate()
			if r >= .4 && r < .6:
				obj = E_BoomPuff3.instantiate()
			if r >= .6 && r < .8:
				obj = E_BoomPuff4.instantiate()
			if r >= .8 && r <= 1:
				obj = E_BoomPuff5.instantiate()
		spawn_objs.EFFECT_FLARE:
			r = randf()
			if r >= 0 && r < .2:
				obj = E_Flare1.instantiate()
			if r >= .2 && r < .4:
				obj = E_Flare2.instantiate()
			if r >= .4 && r < .6:
				obj = E_Flare3.instantiate()
			if r >= .6 && r < .8:
				obj = E_Flare4.instantiate()
			if r >= .8 && r <= 1:
				obj = E_Flare5.instantiate()
			obj.scale = Vector2(1,1)
			obj.modulate = Color(1,1,1,.1)
		spawn_objs.EFFECT_FLASH_BOOM:
			obj = E_Flash_Bloom.instantiate()
		spawn_objs.EFFECT_SMOKE:
			r = randf()
			if r >= 0 && r < .2:
				obj = E_Smoke1.instantiate()
			if r >= .2 && r < .4:
				obj = E_Smoke2.instantiate()
			if r >= .4 && r < .6:
				obj = E_Smoke3.instantiate()
			if r >= .6 && r < .8:
				obj = E_Smoke4.instantiate()
			if r >= .8 && r <= 1:
				obj = E_Smoke5.instantiate()
		spawn_objs.EFFECT_PLASMA_BOOM:
			r = randf()
			if r >= 0 && r < .33:
				obj = E_PlasmaBoom1.instantiate()
			if r >= .33 && r < .66:
				obj = E_PlasmaBoom2.instantiate()
			if r >= .66 && r <= 1:
				obj = E_PlasmaBoom3.instantiate()
		spawn_objs.EFFECT_PLASMA_FLASH:
			obj = E_PlasmaFlash.instantiate()
		spawn_objs.EFFECT_PANG:
			r = randf()
			if r >= 0 && r < .33:
				obj = E_Pang1.instantiate()
			if r >= .33 && r < .66:
				obj = E_Pang2.instantiate()
			if r >= .66 && r <= 1:
				obj = E_Pang3.instantiate()
		spawn_objs.EFFECT_ROCKET_FLASH:
			obj = E_RocketFlash.instantiate()
		spawn_objs.EFFECT_PANG_SPARKS:
			r = randf()
			if r >= 0 && r < .33:
				obj = E_Pang_Sparks1.instantiate()
			if r >= .25 && r < .5:
				obj = E_Pang_Sparks2.instantiate()
			if r >= .5 && r < .75:
				obj = E_Pang_Sparks3.instantiate()
			if r >= .75 && r <= 1:
				obj = E_Pang_Sparks4.instantiate()
		spawn_objs.EFFECT_FIRE:
			obj = E_Fire.instantiate()
			obj.scale = Vector2(.3,.3)
		spawn_objs.EFFECT_SMOKE_TRAIL:
			obj = E_SmokeTrail.instantiate()
			#obj.scale = Vector2(.3,.3)

		#New units:

		spawn_objs.LEGION:
			obj = Ship_Legion.instantiate()

	obj.s = s

	if up == 0:
		game._super_add_child(obj)
		obj.spawn_id = next_spawn_id
		next_spawn_id = next_spawn_id + 1
		obj.pos = position
	if up == 10:
		solarsystem.add_child(obj)
	if up == 11:
		results.add_child(obj)
	if up == 12:
		build_button.add_child(obj)
	if up == 13:
		pass
	if up == 14:
		gui.add_child(obj)
	obj.velocity = velocity
	obj.position = position
	obj.pos = position
	obj.rotation = rotation
	obj.rotate = rotation

	#make sure we actually get a struct or a unit
	if "is_type" in obj:

		if obj.is_type == "STRUCT":
			obj._build_fix()
		if obj.is_type == "SHIP":
			obj._ship_fix()

		#Bug Here
		if p != null && game.players.size() > p:
			obj._set_player(game.players[p])

	return obj

func _spawn_dupe(s, p, position:Vector2, velocity:Vector2, rotation:float, up, init) -> Node2D:
	var obj = s.duplicate()

	if up == 0:
		game._super_add_child(obj)
		obj.spawn_id = next_spawn_id
		next_spawn_id = next_spawn_id + 1

	obj.velocity = velocity
	obj.position = position
	obj.pos = position
	obj.rotation = rotation
	obj.rotate = rotation

	if !obj.is_visible(): obj.show()

	if obj.is_type == "STRUCT":
		obj._build_fix()
	if obj.is_type == "SHIP":
		obj.rotation = 0
	if p != null && game.players.size() > p:
		if obj.has_method("_set_player"):
			obj._set_player(game.players[p])
	return obj

func _spawn_laser(s, p, pa, pb) -> Node2D:
	var obj = s.duplicate()
	game._super_add_child(obj)
	obj.spawn_id = next_spawn_id
	next_spawn_id = next_spawn_id + 1
	obj._ignite(pa,pb)
	if p != null && game.players.size() > p:
		if obj.has_method("_set_player"):
			obj._set_player(game.players[p])
	return obj

func _spawn_hit(s, damage:float, position:Vector2, velocity:Vector2, rotation:float) -> void:
	var obj
	match s:
		"KINETIC":
			obj = _spawn([spawn_objs.EFFECT_IMPACT_KINETIC], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(sqrt(damage) / 4, sqrt(damage) / 4)
		"EXPLOSIVE":
			obj = _spawn([spawn_objs.EXPLODE_BASIC], null, position, velocity, rotation, 0, 0)
		"LASER":
			obj = _spawn([spawn_objs.EFFECT_IMPACT_LASER], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(sqrt(damage) / 4, sqrt(damage) / 4)
		"MINING":
			obj = _spawn([spawn_objs.EFFECT_IMPACT_MINING], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(1.2,1.2)
			obj = _spawn([spawn_objs.EFFECT_SMOKE], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(.3,.3)
			obj.modulate = Color(3,3,3,.6)
		"PHALANX":
			obj = _spawn([spawn_objs.EFFECT_IMPACT_PHALANX], null, position, Vector2(0,0), rotation, 0, 0)
		"REPAIR":
			obj = _spawn([spawn_objs.EFFECT_IMPACT_REPAIR], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(sqrt(abs(damage)) / 4, sqrt(abs(damage)) / 4)
		"PLASMA":
			obj = _spawn([spawn_objs.EXPLODE_PLASMA], null, position, velocity, rotation, 0, 0)
		"SPARTAN":
			obj = _spawn([spawn_objs.EXPLODE_BASIC], null, position, velocity, rotation, 0, 0)
			obj.boom_scale = .7
		"SHIELD":
			obj = _spawn([spawn_objs.EFFECT_IMPACT_SHIELD], null, position, velocity, rotation, 0, 0)
			obj.scale = Vector2(sqrt(damage) / 3, sqrt(damage) / 3)
	
func _spawn_player(faction,variant) -> void:
	var p = Player.new()
	p._set_faction(faction,variant)
	p.id = game.players.size()
	game.players.append(p)

func _spawn_stats() -> Node2D:
	var obj = Stats.instantiate()
	game._super_add_child(obj)
	return obj
