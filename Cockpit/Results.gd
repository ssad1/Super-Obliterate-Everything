extends Node2D

var fireworkson = 0
var fireworkt = 0
var bigfireworkt = 0
var backalpha = 0
var textdissolve = 1.5
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	set_position(Vector2(.5 * GLOBAL.resx, .5 * GLOBAL.resy))
	EVENTS.connect("show_results", Callable(self, "_show_results"))
	EVENTS.connect("hide_results", Callable(self, "_hide_results"))
	EVENTS.connect("flipload", Callable(self, "_flipload"))
	SPAWNER.results = self
	timer = get_node("Timer")
	timer.connect("timeout", Callable(self,"_timeout"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var theta = 0
	var r = 0
	if backalpha < .75:
		backalpha = backalpha + delta
		backalpha = clamp(backalpha,0,.75)
		$Back.modulate = Color(0,0,0,backalpha)
	if fireworkson > 0:
		fireworkson = fireworkson - delta
		fireworkson = clamp(fireworkson,0,1000)
		fireworkt = fireworkt + delta
		bigfireworkt = bigfireworkt + delta
		if fireworkt > 0.1:
			
			var rand_x = $Back.scale.x * randf()
			var rand_y = $Back.scale.y * randf()
			SPAWNER._spawn([10100], null, Vector2(rand_x, rand_y), Vector2(0,0), randf() * 2 * PI, 11,0)
			SPAWNER._spawn([10101], null, Vector2(rand_x, rand_y), Vector2(0,0), randf() * 2 * PI, 11,0)

			fireworkt = 0
		'''if bigfireworkt > 0.75:
			SPAWNER._spawn([10105], null, Vector2(0,0), Vector2(0,0), randf() * 2 * PI, 11,0)
			bigfireworkt = 0'''

func _show_results(r):
	var mat;
	$Back.modulate = Color(0,0,0,0)
	backalpha = 0
	$Defeat.hide()
	$Victory.hide()
	$Disconnect.hide()
	match r:
		1:
			mat = $Defeat.get_material()
			mat.set_shader_parameter("dissolve_strength",1.5)
			$Defeat.show()
		2:
			mat = $Victory.get_material()
			mat.set_shader_parameter("dissolve_strength",1.5)
			$Victory.show()
			fireworkson = 2
			fireworkt = 0
			bigfireworkt = 0
		3:
			mat = $Disconnect.get_material()
			mat.set_shader_parameter("dissolve_strength",1.5)
			$Disconnect.show()
	show()
	timer.set_wait_time(4)
	timer.start()

func _hide_results():
	$Defeat.hide()
	$Victory.hide()
	$Disconnect.hide()
	fireworkson = 0
	hide()

func _flipload():
	_hide_results()

func _timeout():
	GLOBAL.nextscreen = 1
	EVENTS.emit_signal("flipin")
