extends Sprite2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mat
	var d = 0
	mat = get_material()
	d = mat.get_shader_parameter("dissolve_strength")
	if(d > 0):
		d = d - 1 * delta
		clamp(d,0,1.5)
		mat.set_shader_parameter("dissolve_strength",d)
