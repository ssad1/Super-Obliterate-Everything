extends Control

@export var menu_duel_path : NodePath
@export var menu_custom_path : NodePath
@export var menu_ladder_path : NodePath
@export var menu_replays_path : NodePath
@export var menu_button_duel_path : NodePath
@export var menu_button_custom_path : NodePath
@export var menu_button_ladder_path : NodePath
@export var menu_button_replays_path : NodePath

@onready var menu_duel = get_node(menu_duel_path)
@onready var menu_custom = get_node(menu_custom_path)
@onready var menu_ladder = get_node(menu_ladder_path)
@onready var menu_replays = get_node(menu_replays_path)
@onready var menu_button_duel = get_node(menu_button_duel_path)
@onready var menu_button_custom = get_node(menu_button_custom_path)
@onready var menu_button_ladder = get_node(menu_button_ladder_path)
@onready var menu_button_replays = get_node(menu_button_replays_path)

func _ready():
	menu_button_duel.connect("pressed", Callable(self, "on_menu_button_duel_pressed"))
	menu_button_custom.connect("pressed", Callable(self, "on_menu_button_custom_pressed"))
	menu_button_ladder.connect("pressed", Callable(self, "on_menu_button_ladder_pressed"))
	menu_button_replays.connect("pressed", Callable(self, "on_menu_button_replays_pressed"))
	menu_duel.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hide_all_menus():
	menu_duel.hide()
	menu_custom.hide()
	menu_ladder.hide()
	menu_replays.hide()

func on_menu_button_duel_pressed():
	hide_all_menus()
	menu_duel.show()

func on_menu_button_custom_pressed():
	hide_all_menus()
	menu_custom.show()
	
func on_menu_button_ladder_pressed():
	hide_all_menus()
	menu_ladder.show()
	
func on_menu_button_replays_pressed():
	hide_all_menus()
	menu_replays.show()