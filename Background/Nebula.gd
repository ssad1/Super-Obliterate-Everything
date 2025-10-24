extends Sprite2D

@onready var Gradient_T_A := load("res://Effects/Gradients/Gradient_T_A.tres")
@onready var Gradient_T_B := load("res://Effects/Gradients/Gradient_T_B.tres")
@onready var Gradient_T_C := load("res://Effects/Gradients/Gradient_T_C.tres")
@onready var Gradient_T_D := load("res://Effects/Gradients/Gradient_T_D.tres")
@onready var Gradient_T_E := load("res://Effects/Gradients/Gradient_T_E.tres")
@onready var Gradient_T_F := load("res://Effects/Gradients/Gradient_T_F.tres")
@onready var Gradient_C_A := load("res://Effects/Gradients/Gradient_C_A.tres")
@onready var Gradient_C_B := load("res://Effects/Gradients/Gradient_C_B.tres")
@onready var Gradient_C_C := load("res://Effects/Gradients/Gradient_C_C.tres")
@onready var Gradient_C_D := load("res://Effects/Gradients/Gradient_C_D.tres")
@onready var Gradient_VC_A := load("res://Effects/Gradients/Gradient_VC_A.tres")
@onready var Gradient_VC_B := load("res://Effects/Gradients/Gradient_VC_B.tres")
@onready var Gradient_VC_C := load("res://Effects/Gradients/Gradient_VC_C.tres")
@onready var Gradient_H_A := load("res://Effects/Gradients/Gradient_H_A.tres")
@onready var Gradient_H_B := load("res://Effects/Gradients/Gradient_H_B.tres")
@onready var Gradient_H_C := load("res://Effects/Gradients/Gradient_H_C.tres")
@onready var Gradient_H_D := load("res://Effects/Gradients/Gradient_H_D.tres")
@onready var Gradient_VH_A := load("res://Effects/Gradients/Gradient_VH_A.tres")
@onready var Gradient_VH_B := load("res://Effects/Gradients/Gradient_VH_B.tres")
@onready var Gradient_VH_C := load("res://Effects/Gradients/Gradient_VH_C.tres")
@onready var Gradient_VH_D := load("res://Effects/Gradients/Gradient_VH_D.tres")
@onready var Gradient_VH_E := load("res://Effects/Gradients/Gradient_VH_E.tres")
@onready var Gradient_VH_F := load("res://Effects/Gradients/Gradient_VH_F.tres")
@onready var Gradient_VH_G := load("res://Effects/Gradients/Gradient_VH_G.tres")
@onready var Gradient_EX_A := load("res://Effects/Gradients/Gradient_EX_A.tres")
@onready var Gradient_Heat := load("res://Effects/Gradients/Gradient_Laser.tres")

var fade:int = 255
var fadeset:int = 255

func _ready() -> void:
	EVENTS.connect("fadeset", Callable(self,"_fadeset"))
	EVENTS.connect("lightset", Callable(self,"_lightset"))
	EVENTS.connect("envset", Callable(self,"_envset"))

func _process(delta:float) -> void:
	if fade < fadeset:
		fade = fade + 200 * delta
	if fade > fadeset:
		fade = fade - 200 * delta
	if fade + 3 > fadeset && fade - 3 < fadeset:
		fade = fadeset
	if fade > 255:
		fade = 255
	if fade < 0:
		fade = 0
	modulate = Color8(255,255,255,fade)
	_scroll()

func _fadeset(dim:float) -> void:
	fadeset = dim

var mat := get_material()
func _lightset(light, bright) -> void:
	#mat = get_material()
	#mat.set_shader_parameter("smoke_color_b",light * .8)
	pass

func _envset(s:int, a:int, d:int) -> void:
	mat.set_shader_parameter("mode",s)
	match s:
		0:
			hide()
		1:
			mat.set_shader_parameter("colors",_get_gradient(a))
			fadeset = 255
			show()
		2:
			mat.set_shader_parameter("colors",_get_gradient(a))
			mat.set_shader_parameter("corona_direction",d)
			fadeset = 255
			show()
		3:
			mat.set_shader_parameter("colors",_get_gradient(a))
			mat.set_shader_parameter("corona_direction",d)
			fadeset = 255
			show()

func _get_gradient(a:int) -> Resource:
	var g
	match a:
		0:
			g = Gradient_T_A
		1:
			g = Gradient_T_B
		2:
			g = Gradient_T_C
		3:
			g = Gradient_T_D
		4:
			g = Gradient_T_E
		5:
			g = Gradient_T_F
		20:
			g = Gradient_C_A
		21:
			g = Gradient_C_B
		22:
			g = Gradient_C_C
		23:
			g = Gradient_C_D
		40:
			g = Gradient_VC_A
		41:
			g = Gradient_VC_B
		42:
			g = Gradient_VC_C
		60:
			g = Gradient_H_A
		61:
			g = Gradient_H_B
		62:
			g = Gradient_H_C
		63:
			g = Gradient_H_D
		80:
			g = Gradient_VH_A
		81:
			g = Gradient_VH_B
		82:
			g = Gradient_VH_C
		83:
			g = Gradient_VH_D
		84:
			g = Gradient_VH_E
		85:
			g = Gradient_VH_F
		86:
			g = Gradient_VH_G
		100:
			g = Gradient_EX_A
	return g

func _scroll() -> void:
	var scroll := Vector2(0,0)
	scroll = SPAWNER.game.position
	mat.set_shader_parameter("scroll",scroll)
