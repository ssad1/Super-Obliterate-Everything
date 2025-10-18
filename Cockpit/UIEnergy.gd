extends Label

@export var mode = 0 # 1 - Energy, 2 - Metal, 3 - Supply

func _ready():
	if mode == 1:
		EVENTS.connect("ui_energy", Callable(self, "_ui_energy"))
	if mode == 2:
		EVENTS.connect("ui_metal", Callable(self, "_ui_metal"))
	if mode == 3:
		EVENTS.connect("ui_supply", Callable(self, "_ui_supply"))

func _ui_energy(n):
	text = str(floor(n))

func _ui_metal(n):
	text = str(floor(n))

func _ui_supply(n):
	text = str(floor(n))

