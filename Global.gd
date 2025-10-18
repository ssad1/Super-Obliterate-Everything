extends Node

@onready var GalaxyLayer = load("res://Background/GalaxyLayer.tscn")
@onready var StarField = load("res://Background/StarField.tscn")
@onready var Nebula = load("res://Background/Nebula.tscn")
@onready var PlanetSystem = load("res://Background/PlanetSystem.tscn")
@onready var Sunshine = load("res://Game/Sunshine.tscn")
@onready var Game = load("res://Game/Game.tscn")
@onready var DustLayer = load("res://Background/DustLayer.tscn")
@onready var FrostScreen = load("res://Background/FrostScreen.tscn")
@onready var HeatLayer = load("res://Background/Heat_Layer.tscn")
@onready var StarHeatLayer = load("res://Background/Star_Heat_Layer.tscn")
@onready var Results = load("res://Cockpit/Results.tscn")
@onready var BuildSpotLayer = preload("res://Cockpit/Build_Spot_Layer.tscn")
@onready var Square = load("res://Cockpit/Build_Spot_Square.tscn")
@onready var SquareB = load("res://Cockpit/Build_Spot_Square_B.tscn")
@onready var GUI = load("res://GUI.tscn")
@onready var SolarSystem = load("res://Terminal/Solar_System.tscn")
@onready var GalaxyMap = load("res://Terminal/Galaxy/GalaxyMap.tscn")

var resx = 1920
var resy = 1080
var windowx = 1280
var windowy = 720

var nextscreen = 0
var gamemode = 0
var heatbright = 0

var sound_volume = 70
var music_volume = 70

var graphics_quality = 3
var graphics_shake = 1
var graphics_maximized = true

var sell_rate = 0.2

func _set_maximized():
	var size = DisplayServer.screen_get_size()
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_size(Vector2i(size.x + 2, size.y + 2))
	DisplayServer.window_set_position(Vector2i(0, 0))
	graphics_maximized = true
	print("MAXIMIZED")
	
func _set_window():
	var size = DisplayServer.screen_get_size()
	DisplayServer.window_set_size(Vector2i(windowx + 1, windowy + 1))
	DisplayServer.window_set_position(Vector2i(0, 0))
	DisplayServer.window_set_position(Vector2i(size.x / 2 - windowx / 2, size.y / 2 - windowy / 2))
	graphics_maximized = false
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	print("WINDOW")

func _apply_settings():
	if graphics_maximized == true:
		_set_maximized()
	elif graphics_maximized == false:
		_set_window()

func _load_settings():
	print("load test")
	var save_game = FileAccess.open("user://savesettings.save", FileAccess.READ)
	
	if not save_game.file_exists("user://savesettings.save"):
		return # Error! We don't have a save to load.
		
	var data = JSON.parse_string(save_game.get_line())
	sound_volume = data["sound_volume"]
	music_volume = data["music_volume"]
	windowx = data["windowx"]
	windowy = data["windowy"]
	graphics_quality = data["quality"]
	graphics_shake = data["shake"]
	graphics_maximized = data["maximized"]
	
	save_game.close()
	print("load complete")

func _save_settings():
	var save_game = FileAccess.open("user://savesettings.save", FileAccess.WRITE)
	var save_dict = {
		"sound_volume" : sound_volume,
		"music_volume" : music_volume,
		"windowx" : windowx,
		"windowy" : windowy,
		"quality" : graphics_quality,
		"shake" : graphics_shake,
		"maximized" : graphics_maximized
	}
	print("SAVING SETTINGS")
	save_game.store_line(JSON.stringify(save_dict))
	save_game.close()
	print("SAVE SUCCESSFUL")
