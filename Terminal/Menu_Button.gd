extends Button

var menu_id = 0
var mode = 0
var text_save
var text_clock = 0
@export var menu_name = ""
var light
@export var light_on = true

func _ready():
	text_save = text
	light = $Light2D
	EVENTS.connect("button_mash", Callable(self, "_button_mash"))
	#light.set_position(size / 2)
	light.energy = 0

func _process(delta):
	#text_clock = text_clock + 40 * delta
	#if(text != text_save):
	#	text = text_save.left(floor(text_clock) - 2 * menu_id)
	if(toggle_mode == true && light_on == true):
		if(button_pressed == true):
			light.energy = 16
			light.show()
		else:
			light.energy = light.energy - 20 * delta
			if(light.energy <= 0):
				light.energy = 0
				light.hide()

func _pressed():
	SFX._play_new([4004])
	if(mode == 1):
		EVENTS.emit_signal("menu_button_press", name)
		#if(pressed == true):
		#	pressed = false
	if(mode == 2):
		EVENTS.emit_signal("submenu_button_press", name)
		get_parent().saved_button = menu_id

func _button_mash(s):
	if(s == name):
		button_pressed = true
