extends Control

var alpha = 0
var danger_level = 0
var max_danger_level = 0
var conquest_zone_id = 0

@onready var loc_data = $PanelContainer/MarginContainer/VBoxContainer/HFlowContainer/Label_Location_Data
@onready var loc_desc_data = $PanelContainer/MarginContainer/VBoxContainer/HFlowContainer/Label_Location_Data
@onready var level_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Label_Level
@onready var more_danger = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Button_More_Danger
@onready var less_danger = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Button_Less_Danger

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("zone_click", Callable(self, "_on_zone_click"))

func _ignite():

	modulate = Color(1,1,1,0)
	get_tree().create_tween().tween_property(self, "modulate:a", 1.0, 0.3)
	show()

func _cancel():
	SFX._play_new([SFX.sound.BUTTON_ITEM])
	hide()

func _on_zone_click(zone_name, zone_desc, zone_id):
	loc_data.text = zone_name
	loc_desc_data.text = zone_desc
	conquest_zone_id = zone_id
	max_danger_level = ACCOUNT._fetch_danger(conquest_zone_id)
	danger_level = max_danger_level
	level_label.text = str(danger_level)
	_button_vis()
	_ignite()


func _on_Button_Yes_pressed():
	hide()
	SFX._play_new([SFX.sound.CAMPAIGN])
	ACCOUNT._new_campaign(conquest_zone_id,danger_level)
	EVENTS.emit_signal("button_generate_pressed")
	EVENTS.emit_signal("submenu_button_press", "Button_Conquest")
	EVENTS.emit_signal("button_mash", "Button_Conquest")


func _on_Button_More_Danger_pressed():
	if(danger_level < max_danger_level):
		danger_level = danger_level + 1
	_button_vis()
	level_label.text = str(danger_level)
	SFX._play_new([SFX.sound.BUTTON_ITEM])

func _on_Button_Less_Danger_pressed():
	if(danger_level > 1):
		danger_level = danger_level - 1
	_button_vis()
	level_label.text = str(danger_level)
	SFX._play_new([SFX.sound.BUTTON_ITEM])

func _button_vis():
	if(danger_level == max_danger_level):
		more_danger.hide()
	if(danger_level > 1):
		less_danger.show()
	if(danger_level == 1):
		less_danger.hide()
	if(danger_level < max_danger_level):
		more_danger.show()
