extends Control

var button_id = 0
var price = 0
var fading = false
var fade = 1
var booming = false
var boom_clock = 0
var booms = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var obj
	$Label.position.x = 280 - $Label.size.x
	$Credit.position.x = $Label.position.x - 16
	if(booming == true && booms > 0):
		boom_clock = boom_clock + delta
		if(boom_clock > 0.2):
			booms = booms - 1
			for i in range(3):
				obj = SPAWNER._spawn([10300],null,get_global_position() + Vector2(size.x * randf(),size.y * randf()),Vector2(0,0),0,14,0)
				obj.scale = (randf() * .35 + .15) * Vector2(1,1)
		if(booms == 0):
			booming = false
	if(fading == true):
		fade = fade - 2 * delta
		if(fade < 0):
			fade = 0
			hide()
			fading = false
			booming = false
		modulate = Color(1,fade,fade,fade)

func _setup(s,id):
	$Item_Button._equip_item(s)
	$Item_Button.pb = "Prize_Slot"
	button_id = id
	price = ceil(GLOBAL.sell_rate * $Item_Button.obj.credit_cost)
	$Label.text = str(price)
	$Label.position.x = 280 - 2 * $Label.size.x
	$Credit.position.x = $Label.position.x - 16
	

func _sell_pressed():
	var obj
	ACCOUNT._sell_prize_item(button_id,price)
	obj = SPAWNER._spawn([10300],null,get_global_position() + $Sell_Button.position + .5 * $Sell_Button.size,Vector2(0,0),0,14,0)
	obj.scale = Vector2(.75,.75)
	SPAWNER._spawn([10001,price],null,get_global_position() + $Sell_Button.position + .5 * $Sell_Button.size,Vector2(0,0),0,14,0)
	fading = true
	booming = true
	$Sell_Button.hide()
