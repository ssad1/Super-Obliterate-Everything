extends Node2D

var galaxylayer
var starfield
var planetsystem
var nebula
var nebulab
var game
var dustlayer
var frostscreen
var heatlayer
var starheatlayer
var buildspotlayer
var results
var gui

func _ready():
	GLOBAL._load_settings()
	GLOBAL._apply_settings()
	galaxylayer = GLOBAL.GalaxyLayer.instantiate()
	add_child(galaxylayer)
	starfield = GLOBAL.StarField.instantiate()
	add_child(starfield)
	nebula = GLOBAL.Nebula.instantiate()
	add_child(nebula)
	planetsystem = GLOBAL.PlanetSystem.instantiate()
	add_child(planetsystem)
	game = GLOBAL.Game.instantiate()
	add_child(game)
	game.planet_system = planetsystem
	game.hide()
	dustlayer = GLOBAL.DustLayer.instantiate()
	add_child(dustlayer)
	starheatlayer = GLOBAL.StarHeatLayer.instantiate()
	add_child(starheatlayer)
	starheatlayer.hide()
	heatlayer = GLOBAL.HeatLayer.instantiate()
	add_child(heatlayer)
	heatlayer.hide()
	frostscreen = GLOBAL.FrostScreen.instantiate()
	add_child(frostscreen)
	frostscreen.hide()
	results = GLOBAL.Results.instantiate()
	add_child(results)
	results.global_position = Vector2.ZERO
	results.hide()
	buildspotlayer = GLOBAL.BuildSpotLayer.instantiate()
	add_child(buildspotlayer)
	buildspotlayer.hide()
	gui = GLOBAL.GUI.instantiate()
	add_child(gui)
	EVENTS.connect("flipload", Callable(self, "_flipload"))
	
	EVENTS.emit_signal("lightset", Color(1,1,1,1), 1)
	EVENTS.emit_signal("envset",1,0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _flipload():

	if(GLOBAL.nextscreen == 0):
		GLOBAL.gamemode = 0
		EVENTS.emit_signal("lightset", Color(1,1,1,1), 1)
		EVENTS.emit_signal("envset",1,0,0)
	if(GLOBAL.nextscreen == 1):
		GLOBAL.gamemode = 1
		EVENTS.emit_signal("envset",0,0,0)
	if(GLOBAL.nextscreen == 2):
		GLOBAL.gamemode = 2
