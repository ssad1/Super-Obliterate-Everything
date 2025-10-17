extends Control

@export var menu_map_path : NodePath
@export var menu_new_map_path : NodePath

@onready var menu_map = get_node(menu_map_path)
@onready var menu_new_map = get_node(menu_new_map_path)

func _ready():
	EVENTS.connect("show_map", Callable(self, "_show_map"))
	EVENTS.connect("show_new_map", Callable(self, "_show_new_map"))

func _show_map():
	menu_new_map.hide()
	menu_map.show()

func _show_new_map():
	menu_map.hide()
	menu_new_map.show()