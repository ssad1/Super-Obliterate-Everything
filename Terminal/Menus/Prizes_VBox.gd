extends VBoxContainer

@onready var prize_slot = preload("res://Terminal/Menus/Prize_Slot.tscn")
@onready var prize_credits = preload("res://Terminal/Menus/Prize_Credits.tscn")
@onready var prize_boss = preload("res://Terminal/Menus/Prize_Boss.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("setup_prize_slots", Callable(self,"_setup"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _setup():
	var slot
	var mp = ACCOUNT.mission_prizes
	var button_id = 0
	for i in get_child_count():
		if i >= 2:
			if(get_child(i).name != "Button_Done"):
				get_child(i).queue_free()
	for i in mp.size():
		match mp[i][0]:
			0:
				slot = prize_slot.instantiate()
				slot._setup(mp[i][1],button_id)
				add_child(slot)
			1:
				slot = prize_credits.instantiate()
				slot._setup(mp[i][1])
				add_child(slot)
			2:
				slot = prize_boss.instantiate()
				add_child(slot)
		button_id = button_id + 1
	move_child($Button_Done,get_child_count())
	
