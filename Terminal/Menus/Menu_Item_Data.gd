extends PanelContainer

var energy_cost = 0
var metal_cost = 0
var supply_cost = 0
var clock = 0
var fade_out = true
var fade_alpha = 1
@onready var VBox = $MarginContainer/VBox

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	EVENTS.connect("show_menu_item_stats", Callable(self, "_on_show_menu_item_stats"))
	EVENTS.connect("hide_menu_item_stats", Callable(self, "_on_hide_menu_item_stats"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
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

		#fetch simple item data

		var dataContainer = VBox.get_node("UnitInfo/Data")
		var infoContainer = VBox.get_node("UnitInfo/Info")

		var unitClass = VBox.get_node("UIClass")
		var costMenu = VBox.get_node("CostMenu")
		var description = VBox.get_node("Description")
		var uiShield = dataContainer.get_node("UIShield")

		VBox.get_node("UIName").text = o.name_text
		dataContainer.get_node("UIArmor").text = str(int(o.max_armor))
		
		costMenu.get_node("UIEnergy").text = str(o.energy_cost)
		costMenu.get_node("UIMetal").text = str(o.metal_cost)
		costMenu.get_node("UISupply").text = str(o.supply_cost)

		if o.class_text != "":
			unitClass.text = o.class_text
			unitClass.show()
		else:
			unitClass.hide()

		if o.description != "":
			description.text = o.description
			description.show()
		else:
			description.hide()

		if(o.max_shields > 0):
			uiShield.text = str(int(o.max_shields))
			uiShield.show()
			infoContainer.get_node("UIShield").show()
		else:
			uiShield.hide()
			infoContainer.get_node("UIShield").hide()
		
		dataContainer.get_node("UISell").text = str(int(ceil(GLOBAL.sell_rate * o.credit_cost)))

		#fetch the damage from the guns

		var attack = dataContainer.get_node("UIGuns")
		attack.text = ""

		var guns = []
		_get_guns(o, guns)

		var gun_data = []

		for gun in guns:

			var ammo = gun.ammo

			if ammo.name == "Shot_Debris": continue
			if not "damage" in ammo: continue
			
			if "gun_arc_rounds" in gun:
				if gun.gun_arc_rounds > 1:
					gun_data.append(str(int(ammo.damage)) + "x" + str(gun.gun_arc_rounds))
					continue
		
			gun_data.append(str(int(ammo.damage)))
		
		#format the gun text

		if gun_data.size() == 0:
			attack.hide()
			infoContainer.get_node("UIGuns").hide()
		else:
			attack.show()
			infoContainer.get_node("UIGuns").show()
			for i in gun_data.size():
				var data = gun_data[i]
				attack.text += data
				if i < gun_data.size() - 1:
					attack.text += ", "

		#make the box lock near mouse position

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
		
		fade_out = false
		fade_alpha = 1
		modulate = Color(1,1,1,fade_alpha)
		show()
		_do_mouse_filter()

func _get_guns(obj, gun_array:Array) -> void:
	if not "modules" in obj: return
	if obj.modules.size() == 0: return
	for module in obj.modules:
		if module.get_script() == Gun_General || module.get_script() == Gun_Laser:
			gun_array.append(module)
		else:
			_get_guns(module, gun_array)
	

func _on_hide_menu_item_stats():
	fade_out = true

func _do_mouse_filter():
	for i in range(get_child_count()):
		get_child(i).mouse_filter = MOUSE_FILTER_IGNORE
