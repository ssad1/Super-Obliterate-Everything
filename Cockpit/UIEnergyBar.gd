extends TextureRect

var level = 0.0
var mode = 0 # 1 - Energy, 2 - Metal

func _ready():
	var mat = get_material()
	if(mat.get_shader_parameter("shock_strength") > 0):
		mode = 1
		EVENTS.connect("ui_energy", Callable(self, "_ui_energy"))
	if(mat.get_shader_parameter("fire_strength") > 0):
		mode = 2
		EVENTS.connect("ui_metal", Callable(self, "_ui_metal"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _ui_energy(n):
	var mat = get_material()
	level = floor(n) / 1000.0
	mat.set_shader_parameter("shock_height",level)
	

func _ui_metal(n):
	var mat = get_material()
	level = floor(n) / 1000.0
	mat.set_shader_parameter("fire_height",level)
