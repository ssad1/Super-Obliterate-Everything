extends Control

var button_id
var item_id
var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#EVENTS.connect("dragging", Callable(self, "_dragging"))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _dragging(sprite_texture, bid, s):
	set_global_position(get_viewport().get_mouse_position())
	button_id = bid
	item_id = s
	$Sprite2D.texture = sprite_texture
	dragging = true

func _input(event):
	if(GLOBAL.gamemode == 1):
		if visible == false && dragging == true && event is InputEventMouseMotion:
			show()
			EVENTS.emit_signal("hide_menu_item_stats")
		if visible == true:
			set_global_position(get_viewport().get_mouse_position())
		if event is InputEventMouseButton && !event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
			hide()
			$Sprite2D.texture = null
			dragging = false
			if(item_id != null):
				EVENTS.emit_signal("drag_swap", button_id, item_id)
				item_id = null
