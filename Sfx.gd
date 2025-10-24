extends Node

var playlist:Array = []
var newlist:Array = []

@onready var BuildExtractor := load("res://Sounds/Build/BuildExtractor.tscn")
@onready var BuildReactor := load("res://Sounds/Build/BuildReactor.tscn")
@onready var BuildFighter := load("res://Sounds/Build/BuildFighter.tscn")
@onready var BuildCorvette := load("res://Sounds/Build/BuildCorvette.tscn")
@onready var BuildFrigate := load("res://Sounds/Build/BuildFrigate.tscn")
@onready var BuildDestroyer := load("res://Sounds/Build/BuildDestroyer.tscn")
@onready var BuildCruiser := load("res://Sounds/Build/BuildCruiser.tscn")
@onready var BuildCapital := load("res://Sounds/Build/BuildCapital.tscn")
@onready var BuildTurret := load("res://Sounds/Build/BuildTurret.tscn")
@onready var BuildBigTurret := load("res://Sounds/Build/BuildBigTurret.tscn")
@onready var BuildHugeTurret := load("res://Sounds/Build/BuildHugeTurret.tscn")
@onready var BuildShield := load("res://Sounds/Build/BuildShield.tscn")
@onready var BuildBigShield := load("res://Sounds/Build/BuildBigShield.tscn")
@onready var BuildBarricade := load("res://Sounds/Build/BuildBarricade.tscn")
@onready var BuildGas := load("res://Sounds/Build/BuildGas.tscn")
@onready var BuildRadar := load("res://Sounds/Build/BuildRadar.tscn")
@onready var BuildResearch := load("res://Sounds/Build/BuildResearch.tscn")

@onready var DieSmallBoom1 := load("res://Sounds/Death/DieSmallBoom1.tscn")
@onready var DieSmallBoom2 := load("res://Sounds/Death/DieSmallBoom2.tscn")
@onready var DieSmallBoom3 := load("res://Sounds/Death/DieSmallBoom3.tscn")
@onready var DieSmallBoom4 := load("res://Sounds/Death/DieSmallBoom4.tscn")
@onready var DieSmallBoom5 := load("res://Sounds/Death/DieSmallBoom5.tscn")
@onready var DieSmallBoom6 := load("res://Sounds/Death/DieSmallBoom6.tscn")
@onready var DieSmallBoom7 := load("res://Sounds/Death/DieSmallBoom7.tscn")
@onready var DieSmallBoom8 := load("res://Sounds/Death/DieSmallBoom8.tscn")
@onready var DieBigBoom1 := load("res://Sounds/Death/DieBigBoom1.tscn")
@onready var DieBigBoom2 := load("res://Sounds/Death/DieBigBoom2.tscn")
@onready var DieBigBoom3 := load("res://Sounds/Death/DieBigBoom3.tscn")
@onready var DieBigBoom4 := load("res://Sounds/Death/DieBigBoom4.tscn")
@onready var DieBigBoom5 := load("res://Sounds/Death/DieBigBoom5.tscn")
@onready var DieBigBoom6 := load("res://Sounds/Death/DieBigBoom6.tscn")
@onready var DieBigBoom7 := load("res://Sounds/Death/DieBigBoom7.tscn")
@onready var DieBigBoom8 := load("res://Sounds/Death/DieBigBoom8.tscn")
@onready var DieHugeBoom1 := load("res://Sounds/Death/DieHugeBoom1.tscn")
@onready var DieHugeBoom2 := load("res://Sounds/Death/DieHugeBoom2.tscn")
@onready var DieHugeBoom3 := load("res://Sounds/Death/DieHugeBoom3.tscn")
@onready var DieHugeBoom4 := load("res://Sounds/Death/DieHugeBoom4.tscn")
@onready var DieTinyBoom1 := load("res://Sounds/Death/DieTinyBoom1.tscn")
@onready var DieTinyBoom2 := load("res://Sounds/Death/DieTinyBoom2.tscn")
@onready var DieTinyBoom3 := load("res://Sounds/Death/DieTinyBoom3.tscn")
@onready var DieTinyBoom4 := load("res://Sounds/Death/DieTinyBoom4.tscn")

@onready var WeaponPlasma := load("res://Sounds/Weapons/WeaponPlasma.tscn")
@onready var WeaponArtillery1 := load("res://Sounds/Weapons/WeaponArtillery1.tscn")
@onready var WeaponArtillery2 := load("res://Sounds/Weapons/WeaponArtillery2.tscn")
@onready var WeaponArtillery3 := load("res://Sounds/Weapons/WeaponArtillery3.tscn")
@onready var WeaponBeam1 := load("res://Sounds/Weapons/WeaponBeam1.tscn")
@onready var WeaponBeam2 := load("res://Sounds/Weapons/WeaponBeam2.tscn")
@onready var WeaponBeam3 := load("res://Sounds/Weapons/WeaponBeam3.tscn")
@onready var WeaponBeam4 := load("res://Sounds/Weapons/WeaponBeam4.tscn")
@onready var WeaponBeam5 := load("res://Sounds/Weapons/WeaponBeam5.tscn")
@onready var WeaponBlaster1 := load("res://Sounds/Weapons/WeaponBlaster1.tscn")
@onready var WeaponBlaster2 := load("res://Sounds/Weapons/WeaponBlaster2.tscn")
@onready var WeaponBlaster3 := load("res://Sounds/Weapons/WeaponBlaster3.tscn")
@onready var WeaponBlaster4 := load("res://Sounds/Weapons/WeaponBlaster4.tscn")
@onready var WeaponBlaster5 := load("res://Sounds/Weapons/WeaponBlaster5.tscn")
@onready var WeaponMines := load("res://Sounds/Weapons/WeaponMines.tscn")
@onready var WeaponMissile1 := load("res://Sounds/Weapons/WeaponMissile1.tscn")
@onready var WeaponMissile2 := load("res://Sounds/Weapons/WeaponMissile2.tscn")
@onready var WeaponMissile3 := load("res://Sounds/Weapons/WeaponMissile3.tscn")
@onready var WeaponMissile4 := load("res://Sounds/Weapons/WeaponMissile4.tscn")
@onready var WeaponMissile5 := load("res://Sounds/Weapons/WeaponMissile5.tscn")

@onready var GetMetal := load("res://Sounds/Interface/GetMetal.tscn")
@onready var ButtonBuild := load("res://Sounds/Interface/ButtonBuild.tscn")
@onready var BuildError := load("res://Sounds/Interface/BuildError.tscn")
@onready var ButtonGalaxy := load("res://Sounds/Interface/ButtonGalaxy.tscn")
@onready var ButtonTab := load("res://Sounds/Interface/ButtonTab.tscn")
@onready var ButtonItem := load("res://Sounds/Interface/ButtonItem.tscn")
@onready var ButtonEquip := load("res://Sounds/Interface/ButtonEquip.tscn")
@onready var TooPoor := load("res://Sounds/Interface/TooPoor.tscn")
@onready var Campaign := load("res://Sounds/Interface/Campaign.tscn")
@onready var ButtonMenu := load("res://Sounds/Interface/ButtonMenu.tscn")
@onready var ButtonStart := load("res://Sounds/Interface/ButtonStart.tscn")

func _play(s) -> void:
	var sfx
	var r := 0.0
	var dice = 0
	match int(s[0]):
		1000:
			sfx = BuildExtractor.instantiate()
		1001:
			sfx = BuildReactor.instantiate()
		1002:
			sfx = BuildFighter.instantiate()
		1003:
			sfx = BuildCorvette.instantiate()
		1004:
			sfx = BuildFrigate.instantiate()
		1005:
			sfx = BuildDestroyer.instantiate()
		1006:
			sfx = BuildCruiser.instantiate()
		1007:
			sfx = BuildCapital.instantiate()
		1008:
			sfx = BuildTurret.instantiate()
		1009:
			sfx = BuildBigTurret.instantiate()
		1010:
			sfx = BuildHugeTurret.instantiate()
		1011:
			sfx = BuildShield.instantiate()
		1012:
			sfx = BuildBigShield.instantiate()
		1013:
			sfx = BuildBarricade.instantiate()
		1014:
			sfx = BuildGas.instantiate()
		1015:
			sfx = BuildRadar.instantiate()
		1016:
			sfx = BuildResearch.instantiate()
		2000:
			dice = randi() % 8
			match dice:
				0:
					sfx = DieSmallBoom1.instantiate()
				1:
					sfx = DieSmallBoom2.instantiate()
				2:
					sfx = DieSmallBoom3.instantiate()
				3:
					sfx = DieSmallBoom4.instantiate()
				4:
					sfx = DieSmallBoom5.instantiate()
				5:
					sfx = DieSmallBoom5.instantiate()
				6:
					sfx = DieSmallBoom6.instantiate()
				7:
					sfx = DieSmallBoom7.instantiate()
			sfx.volume_db = sfx.volume_db - 5
		2001:
			dice = randi() % 8
			match dice:
				0:
					sfx = DieBigBoom1.instantiate()
				1:
					sfx = DieBigBoom2.instantiate()
				2:
					sfx = DieBigBoom3.instantiate()
				3:
					sfx = DieBigBoom4.instantiate()
				4:
					sfx = DieBigBoom5.instantiate()
				5:
					sfx = DieBigBoom5.instantiate()
				6:
					sfx = DieBigBoom6.instantiate()
				7:
					sfx = DieBigBoom7.instantiate()
		2002:
			dice = randi() % 4
			match dice:
				0:
					sfx = DieHugeBoom1.instantiate()
				1:
					sfx = DieHugeBoom2.instantiate()
				2:
					sfx = DieHugeBoom3.instantiate()
				3:
					sfx = DieHugeBoom4.instantiate()
		2003:
			dice = randi() % 4
			match dice:
				0:
					sfx = DieTinyBoom1.instantiate()
				1:
					sfx = DieTinyBoom2.instantiate()
				2:
					sfx = DieTinyBoom3.instantiate()
				3:
					sfx = DieTinyBoom4.instantiate()
			sfx.volume_db = sfx.volume_db - 7
		3000:
			sfx = WeaponPlasma.instantiate()
			sfx.volume_db = sfx.volume_db - 5
		3001:
			dice = randi() % 5
			match dice:
				0:
					sfx = WeaponBeam1.instantiate()
				1:
					sfx = WeaponBeam2.instantiate()
				2:
					sfx = WeaponBeam3.instantiate()
				3:
					sfx = WeaponBeam4.instantiate()
				4:
					sfx = WeaponBeam5.instantiate()
			sfx.volume_db = sfx.volume_db - 7
			#sfx.pitch_scale = 2
		3002:
			dice = randi() % 5
			match dice:
				0:
					sfx = WeaponBlaster1.instantiate()
				1:
					sfx = WeaponBlaster2.instantiate()
				2:
					sfx = WeaponBlaster3.instantiate()
				3:
					sfx = WeaponBlaster4.instantiate()
				4:
					sfx = WeaponBlaster5.instantiate()
			sfx.volume_db = sfx.volume_db - 10
			
		3003:
			sfx = WeaponMines.instantiate()
			sfx.volume_db = sfx.volume_db - 10
		3004:
			dice = randi() % 5
			match dice:
				0:
					sfx = WeaponMissile1.instantiate()
				1:
					sfx = WeaponMissile2.instantiate()
				2:
					sfx = WeaponMissile3.instantiate()
				3:
					sfx = WeaponMissile4.instantiate()
				4:
					sfx = WeaponMissile5.instantiate()
			sfx.volume_db = sfx.volume_db - 10
		3005:
			dice = randi() % 3
			match dice:
				0:
					sfx = WeaponArtillery1.instantiate()
				1:
					sfx = WeaponArtillery2.instantiate()
				2:
					sfx = WeaponArtillery3.instantiate()
			sfx.volume_db = sfx.volume_db - 5
		3006: #Spartan
			dice = randi() % 5
			match dice:
				0:
					sfx = WeaponBeam1.instantiate()
				1:
					sfx = WeaponBeam2.instantiate()
				2:
					sfx = WeaponBeam3.instantiate()
				3:
					sfx = WeaponBeam4.instantiate()
				4:
					sfx = WeaponBeam5.instantiate()
			sfx.volume_db = sfx.volume_db - 3
			sfx.pitch_scale = .6
		3007: #Deep Blaster
			dice = randi() % 5
			match dice:
				0:
					sfx = WeaponBlaster1.instantiate()
				1:
					sfx = WeaponBlaster2.instantiate()
				2:
					sfx = WeaponBlaster3.instantiate()
				3:
					sfx = WeaponBlaster4.instantiate()
				4:
					sfx = WeaponBlaster5.instantiate()
			sfx.volume_db = sfx.volume_db - 6
			sfx.pitch_scale = .5
		3008: #Mining
			dice = randi() % 5
			match dice:
				0:
					sfx = WeaponBeam1.instantiate()
				1:
					sfx = WeaponBeam2.instantiate()
				2:
					sfx = WeaponBeam3.instantiate()
				3:
					sfx = WeaponBeam4.instantiate()
				4:
					sfx = WeaponBeam5.instantiate()
			sfx.volume_db = sfx.volume_db - 12
			sfx.pitch_scale = 1.3
		3009: #Phalanx
			dice = randi() % 5
			match dice:
				0:
					sfx = WeaponBeam1.instantiate()
				1:
					sfx = WeaponBeam2.instantiate()
				2:
					sfx = WeaponBeam3.instantiate()
				3:
					sfx = WeaponBeam4.instantiate()
				4:
					sfx = WeaponBeam5.instantiate()
			sfx.volume_db = sfx.volume_db - 8
			sfx.pitch_scale = 2
		4000:
			sfx = GetMetal.instantiate()
		4001:
			sfx = ButtonBuild.instantiate()
		4002:
			sfx = BuildError.instantiate()
		4003:
			sfx = ButtonGalaxy.instantiate()
		4004:
			sfx = ButtonTab.instantiate()
		4005:
			sfx = ButtonEquip.instantiate()
		4006:
			sfx = ButtonItem.instantiate()
		4007:
			sfx = TooPoor.instantiate()
		4008:
			sfx = Campaign.instantiate()
		4009:
			sfx = ButtonMenu.instantiate()
		4010:
			sfx = ButtonStart.instantiate()
	sfx.volume_db = sfx.volume_db - 20 * (1 - GLOBAL.sound_volume / 100)
	add_child(sfx)
	sfx.set_position(Vector2(960,540))
	sfx.play()
	sfx.playing = true
	playlist.append(sfx)

func _do_newlist() -> void:
	var i := newlist.size() - 1
	while i > -1:
		if GLOBAL.sound_volume > 0 && playlist.size() < 15:
			_play(newlist[i])
		newlist.remove_at(i)
		i = i - 1
	newlist = []

func _do_playlist() -> void:
	var i := playlist.size() - 1
	while i > -1:
		if !playlist[i].playing:
			remove_child(playlist[i])
			playlist[i].queue_free()
			playlist.remove_at(i)
		i = i - 1

func _do_tick() -> void:
	_do_newlist()
	_do_playlist()

func _play_new(s) -> void:
	var found := false
	for i in newlist.size():
		if newlist[i][0] == s[0]:
			found = true
	if !found:
		newlist.append(s)
