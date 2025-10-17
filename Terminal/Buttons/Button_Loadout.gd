extends Button

var loadout = 1

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	loadout = loadout + 1
	if(loadout == 4):
		loadout = 1
	if(loadout == 1):
		text = "LOAD 1"
	if(loadout == 2):
		text = "LOAD 2"
	if(loadout == 3):
		text = "LOAD 3"