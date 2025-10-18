extends TextureButton

var p
var pb
var id
var item_id = null
var priority_obj
var obj
var factory_obj
var item_data = []

@onready var sprite = $Sprite2D
@onready var hotkey = $Hotkey

var equip_me = false
var sprite_shrink = false
var fading = false
var fade = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	p = str(get_parent().name)
	if(p == "ItemGrid"):
		pb = str(get_parent().get_parent().get_parent().name)
		if(pb == "Menu_Sell"):
			toggle_mode = true
	EVENTS.connect("new_build_spot", Callable(self, "_new_build_spot"))
	EVENTS.connect("unequip_buttons", Callable(self, "_unequip_buttons"))
	EVENTS.connect("equip_buttons", Callable(self, "_equip_buttons"))
	if(p == "ArmoryGrid"):
		EVENTS.connect("drag_swap", Callable(self, "_drag_swap"))
		EVENTS.connect("drag_swap_b", Callable(self, "_drag_swap_b"))

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if(pb == "Menu_Sell"):
		if(weakref(obj).get_ref() == null):
			button_pressed = false
		if(button_pressed == true):
			sprite.scale = Vector2(1.4,1.4)
		else:
			if(is_hovered() == false):
				sprite_shrink = true
	if(sprite_shrink == true):
		sprite.scale = Vector2(sprite.scale.x - 5 * delta, sprite.scale.y - 5 * delta)
		if(sprite.scale.x <= 1):
			sprite.scale = Vector2(1,1)
			sprite_shrink = false
	if(p == "CockpitGrid"):
		if(Input.is_key_pressed(KEYMAPS.BuildGrid[id])):
			_pressed()
	if(fading == true):
		fade = fade - 2 * delta
		if(fade < 0):
			fade = 0
			fading = false
		sprite.modulate = Color(1,fade,fade,fade)

func _button_down():
	if p == "ArmoryGrid":
		EVENTS.emit_signal("dragging", $Sprite2D.texture, id, item_id)

func _drag_swap(button_id, s):
	var current_id = item_id
	var mp = get_viewport().get_mouse_position()
	var bp = global_position
	if(mp.x > bp.x && mp.x < bp.x + 64 && mp.y > bp.y && mp.y < bp.y + 64):
		if(s != null):
			_clear_obj()
			item_id = s
			ACCOUNT._equip_item(id,item_id)
			_equip_item(ACCOUNT.item_bag[item_id])
			EVENTS.emit_signal("drag_swap_b", button_id, current_id)
			SFX._play_new([4006])

func _drag_swap_b(button_id, current_id):
	if(id == button_id):
		if(current_id != null):
			_clear_obj()
			item_id = current_id
			ACCOUNT._equip_item(id,current_id)
			_equip_item(ACCOUNT.item_bag[current_id])
		else:
			item_id = null
			_clear_obj()
			ACCOUNT._equip_item(id,null)

func _pressed():
	if(p == "ArmoryGrid"):
		_pressed_armory()
	if(p == "MarketGrid"):
		_pressed_market()
	if(p == "ItemGrid"):
		if(pb == "Menu_EquipSelect"):
			_pressed_equip()
			_pressed_item()
		if(pb == "Menu_Sell"):
			_pressed_sell()
	if(p == "CockpitGrid"):
		_pressed_cockpit()
	if(pb == "Prize_Slot"):
		_pressed_prize()
	if(p.substr(0,5) == "Draft"):
		_pressed_draft()

func _mouse_entered():
	sprite.scale = Vector2(1.4,1.4)
	if(p == "CockpitGrid" && weakref(obj).get_ref() != null):
		EVENTS.emit_signal("show_item_stats", position, obj.name_text, obj.energy_cost, obj.metal_cost, obj.supply_cost)
	if(p == "ArmoryGrid"):
		EVENTS.emit_signal("show_menu_item_stats", global_position, obj)	
		#EVENTS.emit_signal("dragging",$Sprite2D.texture,id)
	if(p == "ItemGrid"):
		EVENTS.emit_signal("show_menu_item_stats", global_position, obj)
	if(pb == "Prize_Slot"):
		EVENTS.emit_signal("show_menu_item_stats", global_position, obj)
	if(p.substr(0,5) == "Draft"):
		EVENTS.emit_signal("close_draft_buy")
		EVENTS.emit_signal("show_menu_item_stats", global_position, obj)

func _mouse_exited():
	if(button_pressed == false):
		sprite_shrink = true
	if(p == "CockpitGrid"):
		EVENTS.emit_signal("hide_item_stats")
	if(p == "ArmoryGrid"):
		EVENTS.emit_signal("hide_menu_item_stats")
	if(p == "ItemGrid"):
		EVENTS.emit_signal("hide_menu_item_stats")
	if(pb == "Prize_Slot"):
		EVENTS.emit_signal("hide_menu_item_stats")
	if(p.substr(0,5) == "Draft"):
		EVENTS.emit_signal("hide_menu_item_stats")

func _pressed_armory():
	SFX._play_new([4006])
	EVENTS.emit_signal("unequip_buttons")
	equip_me = true
	EVENTS.emit_signal("submenu_button_press","Button_EquipSelect")
	EVENTS.emit_signal("hide_menu_item_stats")
	EVENTS.emit_signal("setup_items",0)
	sprite.scale = Vector2(1,1)

func _pressed_equip():
	#Do Equipment Stuff
	SFX._play_new([4006])
	sprite.scale = Vector2(1,1)
	EVENTS.emit_signal("submenu_button_press","Button_Equip")
	EVENTS.emit_signal("hide_menu_item_stats")
	EVENTS.emit_signal("equip_buttons",item_id)
	

func _pressed_market():
	pass

func _pressed_item():
	SFX._play_new([4006])
	EVENTS.emit_signal("show_menu_armory")

func _pressed_sell():
	SFX._play_new([4006])
	if(button_pressed == false):
		_mouse_exited()
	if(button_pressed == true):
		#_mouse_exited()
		EVENTS.emit_signal("show_menu_item_stats", global_position, obj)	

func _pressed_cockpit():
	var r = 0
	SFX._play_new([4006])
	button_pressed = true
	sprite.scale = Vector2(1,1)

	if(weakref(obj).get_ref() != null):

		if("range_radius" in obj):
			r = obj.range_radius
		if("factory" in obj):
			#Ship

			EVENTS.emit_signal(
				"new_build_spot",
				id+1,
				factory_obj.build_size, 
				[obj.energy_cost, obj.metal_cost, obj.supply_cost],
				0, 
				obj.name_text, 
				obj.shield_radius
			)
		else:
			#Structure
			EVENTS.emit_signal(
				"new_build_spot",
				id+1,
				obj.build_size, 
				[obj.energy_cost, obj.metal_cost, obj.supply_cost],
				r, 
				obj.name_text, 
				obj.shield_radius
			)
	EVENTS.emit_signal("hide_item_stats")
	EVENTS.emit_signal("hide_menu_options")
	#print(KEYMAPS.BuildGrid[id])

func _pressed_draft():
	print("Draft Press")
	print(obj.s)
	SFX._play_new([4006])
	EVENTS.emit_signal("show_draft_buy",id, global_position, obj.s, obj.name_text, obj.credit_cost)

func _pressed_prize():
	pass

func _clear_obj():
	item_data = []
	item_id = null
	if(weakref(obj).get_ref() != null):
		obj.queue_free()
		obj = null
	if(weakref(factory_obj).get_ref() != null):
		factory_obj.queue_free()
		factory_obj = null
	$Sprite2D.texture = null
	$Sprite_Equipped.hide()

func _equip_item(s):
	if weakref(obj).get_ref() != null:
		_clear_obj()
	item_data = s
	_spawn_obj(item_data)
	if p == "ItemGrid":
		$Sprite_Equipped.visible = ACCOUNT._check_equipped(item_id)

func _spawn_obj(s):
	var t
	SPAWNER.build_button = self
	
	if GLOBAL.gamemode == 2 && SPAWNER.game.me != null:
		obj = SPAWNER._spawn(s, SPAWNER.game.me.id, Vector2(0,0), Vector2(0,0), 0, 12,0)
		if "factory" in obj:
			factory_obj = SPAWNER._spawn([obj.factory], null, Vector2(0,0), Vector2(0,0), 0, 12,0)
			_remove_obj_from_grid(factory_obj)
		hotkey.show()
	else:
		obj = SPAWNER._spawn(s, null, Vector2(0,0), Vector2(0,0), 0, 12,0)
		if hotkey != null: 
			hotkey.hide()
	
	if "range_radius" in obj:
		_remove_obj_from_grid(obj)
	t = ICONS._get_icon(obj.name_text)
	if t != null:
		$Sprite2D.texture = t
	if weakref(factory_obj).get_ref() != null:
		priority_obj = factory_obj
	else:
		priority_obj = obj

#to not mess up AI in-game / not make unecessary expensive calculations

func _remove_obj_from_grid(obj:Thing) -> void:

	if is_instance_valid(obj.hitbox):
		obj.hitbox.queue_free()
		obj.tcpu.queue_free()
		
	obj.hide()

func _new_build_spot(a,b,c,d,e,f):
	pass

func _unequip_buttons():
	if(get_parent().name == "ArmoryGrid"):
		equip_me = false

func _equip_buttons(s):
	if(get_parent().name == "ArmoryGrid"):
		if(equip_me == true):
			_clear_obj()
			item_id = s
			if(item_id != null):
				_equip_item(ACCOUNT.item_bag[item_id])
				ACCOUNT._equip_item(id,item_id)
			else:
				_clear_obj()
				ACCOUNT._equip_item(id,null)
			equip_me = false
		else:
			if(item_id == s):
				_clear_obj()
				ACCOUNT._equip_item(id,null)

func _sell():
	var e
	var bscale = .25 * randf()
	var price = ceil(GLOBAL.sell_rate * obj.credit_cost)
	ACCOUNT._sell_item(item_id,price)
	e = SPAWNER._spawn([10300],null,get_global_position() + .5 * size,Vector2(0,0),0,14,0)
	e.scale = Vector2(.75 + bscale,.75 + bscale)
	SPAWNER._spawn([10001,price],null,get_global_position() + .5 * size,Vector2(0,0),0,14,0)
	button_pressed = false
	_clear_obj()
