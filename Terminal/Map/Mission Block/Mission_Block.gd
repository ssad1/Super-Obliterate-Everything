extends Node2D

var alpha = 0
var dimensions = Vector2(0,0)

@onready var info_root:VBoxContainer = $PanelContainer/MarginContainer/Box
@onready var terminal_prize = preload("res://Terminal/Menus/Mission_Terminal_Prize.tscn")
@onready var rewards = info_root.get_node("RewardGrid")

func _ready():
	EVENTS.connect("mission_hover_in", Callable(self, "_on_mission_hover_in"))
	EVENTS.connect("mission_hover_out", Callable(self, "_on_mission_hover_out"))
	EVENTS.connect("flipin", Callable(self, "_on_flipin"))
	dimensions = $PanelContainer.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(alpha < 1):
		alpha = alpha + 5 * delta
	if(alpha > 1):
		alpha = 1
	modulate = Color(1,1,1,alpha)

func _on_mission_hover_in(m):
	var pos:Vector2 = m.position + m.get_parent().position
	var p := Vector2(pos.x + 20 + 16,pos.y - dimensions.y - 20 + 16)
	if(p.y < 150):
		p.y = 150
	if(p.x + dimensions.x > 1450):
		p.x = pos.x - 16 - dimensions.x
	
	set_position(p)
	
	info_root.get_node("Mission_Type").text = m.mission_data[0]
	info_root.get_node("Mission_Factions")._generate_factions(m.mission_data[1])

	var data = info_root.get_node("MissionInfo/Data")
	data.get_node("Mission_Map").text = str(m.mission_data[2])
	data.get_node("Mission_Size").text = str(m.mission_data[3])
	data.get_node("Mission_Temperature").text = str(m.mission_data[4])
	data.get_node("Mission_Difficulty").text = str(m.mission_data[5])
	data.get_node("Mission_Resources").text = str(m.mission_data[7])
	data.get_node("Mission_Planet").text = str(m.mission_data[8])
	data.get_node("Mission_Asteroids").text = str(m.mission_data[9])
	
	var rewards = info_root.get_node("RewardGrid")

	var prizes = m.mission_data[10]
	for prize in prizes:

		var item = terminal_prize.instantiate()
		rewards.add_child(item)

		#treat credits
		if prize[0] == 1:
			item.Do_Prize(prize[0], prize[1], null)
		else:
		#treat actual units
			item.Do_Prize(prize[0], 0, prize[1][0])

	alpha = 0
	modulate = Color(1,1,1,alpha)
	show()

func _on_mission_hover_out():
	hide()

	for child in rewards.get_children():
		child.queue_free()

func _on_flipin():
	hide()
