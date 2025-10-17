extends ColorRect

var energy_cost = 0
var metal_cost = 0
var supply_cost = 0
var clock = 0
var fade_out = true
var fade_alpha = 1
@onready var VBox = $VBox

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	EVENTS.connect("show_menu_item_stats", Callable(self, "_on_show_menu_item_stats"))
	EVENTS.connect("hide_menu_item_stats", Callable(self, "_on_hide_menu_item_stats"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clock = clock + delta
	modulate = Color(1,1,1,fade_alpha)
	if(fade_out == true):
		fade_alpha = fade_alpha - 5 * delta
		if(fade_alpha <= 0 ):
			hide()
			fade_alpha = 0
			fade_out = false

func _on_show_menu_item_stats(p,o):
	if(weakref(o).get_ref() != null):
		#energy_cost = e
		#metal_cost = m
		#supply_cost = s
		$VBox/UIName.text = o.name_text
		$VBox/UIName/UIName2.text = o.name_text
		$VBox/CostMenu/UIEnergy.text = str(o.energy_cost)
		$VBox/CostMenu/UIMetal.text = str(o.metal_cost)
		$VBox/CostMenu/UISupply.text = str(o.supply_cost)
		if(o.class_text != ""):
			$VBox/UIClass.text = str(o.class_text)
			$VBox/UIClass.show()
		else:
			$VBox/UIClass.hide()
		$VBox/UIArmor.text = "ARMOR: " + str(o.max_armor)
		if(o.max_shields > 0):
			$VBox/UIShield.text = "SHIELDS: " + str(o.max_shields)
			$VBox/UIShield.show()
		else:
			$VBox/UIShield.hide()
		$VBox/UICredits.text = "SELL: " + str(ceil(GLOBAL.sell_rate * o.credit_cost))
		
		VBox.set_size(Vector2(1,1))
		size = VBox.size
		global_position = p
		position.y = position.y - size.y - 4
		position.x = position.x + 32 - .5 * size.x
		if(global_position.y < 155):
			global_position = p
			global_position.y = 155
			position.x = position.x + 68
		if(global_position.x + size.x > 1422):
			global_position = p
			global_position.y = 155
			position.x = position.x - size.x - 4
		#if(position.x < 0):
			#position.x = 0
		#if(position.x + size.x > 410): #684
			#position.x = 410 - size.x
		
		fade_out = false
		fade_alpha = 1
		modulate = Color(1,1,1,fade_alpha)
		show()
		_do_mouse_filter()

func _on_hide_menu_item_stats():
	fade_out = true

func _do_mouse_filter():
	for i in range(get_child_count()):
		get_child(i).mouse_filter = MOUSE_FILTER_IGNORE
