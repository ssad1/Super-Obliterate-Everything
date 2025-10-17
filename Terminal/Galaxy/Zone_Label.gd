extends Control

@onready var label = $Label
@onready var back = $ColorRect
var dimensions = Vector2(0,0)
var alpha = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("zone_hover_in", Callable(self, "_zone_hover_in"))
	EVENTS.connect("zone_hover_out", Callable(self, "_zone_hover_out"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.size = Vector2(10,10)
	back.size = label.size
	
	if(alpha < 1):
		alpha = alpha + 5 * delta
	if(alpha > 1):
		alpha = 1
	modulate = Color(1,1,1,alpha)

func _zone_hover_in(m,s):
	var pos:Vector2
	var p
	label.size = Vector2(10,10)
	label.text = " " + s + " "
	back.size = label.size
	dimensions = label.size
	pos = m.position + m.get_parent().position
	p = Vector2(pos.x + 20 + 16,pos.y - dimensions.y - 20 + 16)
	#if(p.y < 150):
	#	p.y = 150
	#if(p.x + dimensions.x > 1450):
	#	p.x = pos.x - 16 - dimensions.x
	alpha = 0
	modulate = Color(1,1,1,alpha)
	set_global_position(p)
	show()

func _zone_hover_out():
	hide()
