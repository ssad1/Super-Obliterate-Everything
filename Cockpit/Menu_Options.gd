extends Control

@export var menu_exit_path: NodePath
@export var menu_settings_path: NodePath
@export var menu_controls_path: NodePath
@export var menu_button_exit_path: NodePath
@export var menu_button_settings_path: NodePath
@export var menu_button_controls_path: NodePath
@export var menu_button_x_path: NodePath

@onready var menu_exit: Control = get_node(menu_exit_path)
@onready var menu_settings: Control = get_node(menu_settings_path)
@onready var menu_controls: Control = get_node(menu_controls_path)
@onready var menu_button_exit: Button = get_node(menu_button_exit_path)
@onready var menu_button_settings: Button = get_node(menu_button_settings_path)
@onready var menu_button_controls: Button = get_node(menu_button_controls_path)
@onready var menu_button_x: Button = get_node(menu_button_x_path)

var pop: float = 1.0
var pop_in: bool = true
var esc_trigger: bool = false

func _ready():

	menu_button_exit.pressed.connect(Callable(self, "on_menu_button_exit_pressed"))
	menu_button_settings.pressed.connect(Callable(self, "on_menu_button_settings_pressed"))
	menu_button_controls.pressed.connect(Callable(self, "on_menu_button_controls_pressed"))
	menu_button_x.pressed.connect(Callable(self, "on_menu_button_x_pressed"))

	menu_exit.show()

	EVENTS.connect("show_menu_options", Callable(self, "on_show_menu_options"))
	EVENTS.connect("hide_menu_options", Callable(self, "on_hide_menu_options"))

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE) and not esc_trigger:
		if not visible:
			EVENTS.emit_signal("cancel_build")
		on_show_menu_options()
		esc_trigger = true
	if not Input.is_key_pressed(KEY_ESCAPE):
		esc_trigger = false

	# Pop animation
	if pop_in:
		pop = min(pop + 5.0 * delta, 1.0)
	else:
		pop = max(pop - 5.0 * delta, 0.0)
		if pop <= 0.7:
			hide()
	
	scale = Vector2(pop, pop)

func hide_all_menus():
	menu_exit.hide()
	menu_settings.hide()
	menu_controls.hide()

	if not pop_in:
		menu_button_exit.light.energy = 0
		menu_button_settings.light.energy = 0
		menu_button_controls.light.energy = 0

func on_menu_button_exit_pressed():
	hide_all_menus()
	menu_exit._ignite()

func on_menu_button_settings_pressed():
	hide_all_menus()
	menu_settings._ignite()

func on_menu_button_controls_pressed():
	hide_all_menus()
	menu_controls._ignite()

func on_menu_button_x_pressed():
	pop_in = false

func on_show_menu_options():
	if not visible:
		hide_all_menus()
		pop = 0.5
		pop_in = true
		scale = Vector2(pop, pop)

		menu_button_exit.button_pressed = true

		menu_exit._ignite()
		show()
	else:
		pop_in = false

func on_hide_menu_options():
	pop_in = false
