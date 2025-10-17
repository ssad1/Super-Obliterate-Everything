extends Node2D

var energy_cost = 0
var metal_cost = 0
var supply_cost = 0
var clock = 0
var fade_out = true
var fade_alpha = 1

func _ready():
	EVENTS.connect("show_item_stats", Callable(self, "_on_show_item_stats"))
	EVENTS.connect("hide_item_stats", Callable(self, "_on_hide_item_stats"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clock = clock + delta
	if(visible == true):
		_cost_colors()
	modulate = Color(1,1,1,fade_alpha)
	if(fade_out == true):
		fade_alpha = fade_alpha - 5 * delta
		if(fade_alpha <= 0 ):
			hide()
			fade_alpha = 0
			fade_out = false

func _on_show_item_stats(p,n,e,m,s):
	position = p
	position.y = position.y - 68
	position.x = position.x + 32 - .5 * 300
	if(position.x < 0):
		position.x = 0
	if(position.x + 150 > 410): #684
		position.x = 410 - 150
	energy_cost = e
	metal_cost = m
	supply_cost = s
	$VBox/UIName.text = n
	$VBox/UIName/UIName2.text = n
	$VBox/CostMenu/UIEnergy.text = str(energy_cost)
	$VBox/CostMenu/UIMetal.text = str(metal_cost)
	$VBox/CostMenu/UISupply.text = str(supply_cost)
	_cost_colors()
	fade_out = false
	fade_alpha = 1
	modulate = Color(1,1,1,fade_alpha)
	show()

func _on_hide_item_stats():
	fade_out = true

func _cost_colors():
	var costly = false
	var red = Color(1,.2,.2,1)
	var flash_white = Color(.7 + .3 * sin(15 * clock),.7 + .3 * sin(15 * clock),.7 + .3 * sin(15 * clock),1)
	var white = Color(1,1,1,1)
	if(SPAWNER.game.me != null):
		if(SPAWNER.game.me.energy < energy_cost):
			$VBox/CostMenu/UIEnergy.modulate = red
			costly = true
		else:
			$VBox/CostMenu/UIEnergy.modulate = white
		if(SPAWNER.game.me.metal < metal_cost):
			$VBox/CostMenu/UIMetal.modulate = red
			costly = true
		else:
			$VBox/CostMenu/UIMetal.modulate = white
		if(SPAWNER.game.me.supply < supply_cost):
			$VBox/CostMenu/UISupply.modulate = red
			costly = true
		else:
			$VBox/CostMenu/UISupply.modulate = white
	if(costly == true):
		$VBox/UIName.modulate = red
	else:
		$VBox/UIName.modulate = flash_white
