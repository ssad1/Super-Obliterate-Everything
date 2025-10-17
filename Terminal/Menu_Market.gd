extends Control

@export var menu_shop_path : NodePath
@export var menu_packs_path : NodePath
@export var menu_extra_path : NodePath
@export var menu_button_shop_path : NodePath
@export var menu_button_packs_path : NodePath
@export var menu_button_extra_path : NodePath

@onready var menu_shop = get_node(menu_shop_path)
@onready var menu_packs = get_node(menu_packs_path)
@onready var menu_extra = get_node(menu_extra_path)
@onready var menu_button_shop = get_node(menu_button_shop_path)
@onready var menu_button_packs = get_node(menu_button_packs_path)
@onready var menu_button_extra = get_node(menu_button_extra_path)

func _ready():
	menu_button_shop.connect("pressed", Callable(self, "on_menu_button_shop_pressed"))
	menu_button_packs.connect("pressed", Callable(self, "on_menu_button_packs_pressed"))
	menu_button_extra.connect("pressed", Callable(self, "on_menu_button_extra_pressed"))
	menu_shop.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hide_all_menus():
	menu_shop.hide()
	menu_packs.hide()
	menu_extra.hide()

func on_menu_button_shop_pressed():
	hide_all_menus()
	menu_shop.show()

func on_menu_button_packs_pressed():
	hide_all_menus()
	menu_packs.show()
	
func on_menu_button_extra_pressed():
	hide_all_menus()
	menu_extra.show()
