extends Sprite2D

@export var animator_path: NodePath

@onready var animator = get_node(animator_path)
var final = false

func _ready():
	set_rotation(PI / 2 * float(randi() % 4))
	hide()
	pass

#func _process(delta):
#	pass

func _set_delay(d):
	animator.delay = d
	final = false

func _set_final():
	final = true
	
func _in_completed():
	if(final == true):
		EVENTS.emit_signal("flipload")

func _out_completed():
	hide()
	if(final == true):
		#EVENTS.emit_signal("flipin")
		EVENTS.emit_signal("flipcomplete")
