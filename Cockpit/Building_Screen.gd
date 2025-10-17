extends Control

var fade_in = false
var fade_alpha = 0
@onready var build_text = $Build_Text
@onready var alert_text = $Alert_Text

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("cancel_build", Callable(self,"_cancel_build"))
	EVENTS.connect("new_build_spot", Callable(self, "_new_build_spot"))
	EVENTS.connect("build_alert", Callable(self,"_build_alert"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(fade_in == true):
		fade_alpha = fade_alpha + 5 * delta
		if(fade_alpha >= 1):
			fade_alpha = 1
			fade_in = false
	modulate = Color(1,1,1,fade_alpha)

func _new_build_spot(a,b,c,d,e,f):
	build_text.text = "BUILD " + e
	alert_text.text = ""
	if(visible == false):
		fade_in = true
		modulate = Color(1,1,1,fade_alpha)
		show()

func _cancel_build():
	hide()
	fade_in = false
	fade_alpha = 0
	modulate = Color(1,1,1,fade_alpha)

func _build_alert(s):
	alert_text.text = s
