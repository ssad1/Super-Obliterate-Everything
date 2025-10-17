extends TextureButton

var p
var id
var obj
var item_data = []
var item_light_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	p = get_parent().name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ilight = $Item_Light
	if(item_light_on == true):
		ilight.energy = 10
		ilight.show()
	else:
		if(ilight.visible == true):
			ilight.energy = ilight.energy - delta * 20
			if(ilight.energy <= 0):
				ilight.hide()
				ilight.energy = 0

func _pressed():
	if(p == ""):
		_pressed_armory()
	if(p == ""):
		_pressed_market()
	if(p == ""):
		_pressed_item()
	if(p == "Building_Screen"):
		_pressed_cockpit()

func _mouse_entered():
	item_light_on = true

func _mouse_exited():
	item_light_on = false

func _pressed_armory():
	pass

func _pressed_market():
	pass

func _pressed_item():
	pass

func _pressed_cockpit():
	EVENTS.emit_signal("cancel_build")
