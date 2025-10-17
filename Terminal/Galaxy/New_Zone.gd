extends Control

var alpha = 0
var danger_level = 0
var max_danger_level = 0
var conquest_zone_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("zone_click", Callable(self, "_on_zone_click"))

func _process(delta):
	if(visible == true):
		if(alpha < 1):
			alpha = alpha + 3 * delta
			if(alpha > 1):
				alpha = 1
			modulate = Color(1,1,1,alpha)

func _ignite():
	alpha = 0
	modulate = Color(1,1,1,alpha)
	show()

func _cancel():
	SFX._play_new([4006])
	hide()

func _on_zone_click(zone_name, zone_desc, zone_id):
	$Label_Location_Data.text = zone_name
	$Label_Description_Data.text = zone_desc
	conquest_zone_id = zone_id
	max_danger_level = ACCOUNT._fetch_danger(conquest_zone_id)
	danger_level = max_danger_level
	$Label_Level.text = str(danger_level)
	_button_vis()
	_ignite()


func _on_Button_Yes_pressed():
	hide()
	SFX._play_new([4008])
	ACCOUNT._new_campaign(conquest_zone_id,danger_level)
	EVENTS.emit_signal("button_generate_pressed")
	EVENTS.emit_signal("submenu_button_press", "Button_Conquest")
	EVENTS.emit_signal("button_mash", "Button_Conquest")


func _on_Button_More_Danger_pressed():
	if(danger_level < max_danger_level):
		danger_level = danger_level + 1
	_button_vis()
	$Label_Level.text = str(danger_level)
	SFX._play_new([4006])

func _on_Button_Less_Danger_pressed():
	if(danger_level > 1):
		danger_level = danger_level - 1
	_button_vis()
	$Label_Level.text = str(danger_level)
	SFX._play_new([4006])

func _button_vis():
	if(danger_level == max_danger_level):
		$Button_More_Danger.hide()
	if(danger_level > 1):
		$Button_Less_Danger.show()
	if(danger_level == 1):
		$Button_Less_Danger.hide()
	if(danger_level < max_danger_level):
		$Button_More_Danger.show()
