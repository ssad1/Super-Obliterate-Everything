extends Control

@onready var solarsystem
@onready var galaxymap
var clock = 0

func _ready():
	EVENTS.connect("logout", Callable(self, "_logout"))
	EVENTS.connect("user_login", Callable(self, "_user_login"))
	EVENTS.connect("flipload", Callable(self, "_flipload"))
	#self.modulate = Color8(255,150,150,255)
	solarsystem = GLOBAL.SolarSystem.instantiate()
	add_child(solarsystem)
	solarsystem.hide()
	galaxymap = GLOBAL.GalaxyMap.instantiate()
	add_child(galaxymap)
	galaxymap.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clock = clock + delta
	if(clock > .1):
		clock = clock - .1
		SFX._do_tick()

func _hide_all_menus():
	solarsystem.hide()
	galaxymap.hide()
	$Mission_Block.hide()

func _logout():
	GLOBAL.nextscreen = 0
	EVENTS.emit_signal("flipin")

func _user_login(userid):
	#_hide_all_menus()
	#_show_menu_bar()
	#on_menu_button_campaign_pressed()
	#menu_button_campaign.button_pressed = true
	GLOBAL.nextscreen = 1
	EVENTS.emit_signal("flipin")
	pass

func _flipload():
	if(GLOBAL.nextscreen == 0):
		hide()
		_hide_all_menus()
		EVENTS.emit_signal("flipout")
	if(GLOBAL.nextscreen == 1):
		_hide_all_menus()
		show()
		EVENTS.emit_signal("flipout")
		#EVENTS.emit_signal("menu_button_press", "Button_Missions")
		if(ACCOUNT.mission_prizes == []):
			EVENTS.emit_signal("submenu_button_press", "Button_Conquest")
		if(ACCOUNT.mission_prizes != []):
			EVENTS.emit_signal("submenu_button_press", "Button_Prizes")
			EVENTS.emit_signal("setup_prize_slots")
			ACCOUNT._do_prizes()
	if(GLOBAL.nextscreen == 2):
		hide()
		_hide_all_menus()
