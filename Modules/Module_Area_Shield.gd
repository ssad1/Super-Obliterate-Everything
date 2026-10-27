extends ColorRect

@onready var shield_line = $Shield_Line
@onready var glow = $ShieldGlow.get_material()

@onready var up = get_parent()
var pos:Vector2 = Vector2(0,0)
var is_type:UNIT_STATE.type = UNIT_STATE.type.SHIELD
var shield_power:float = 0
var shield_theta:float = 0
@export var shield:float = 30
@export var max_shield:float = 30
@export var shield_radius:int = 100
@export var shield_width:int = 32
@export var shield_charge:float = 1

var shield_mode:int = 1 #0 broken, 1 normal, 2 charging
var charge_t:int = 0
var max_charge:float = 20

func _ready() -> void:
	up.modules.append(self)

	_gen_circle(shield_radius)
	show()

func _process(delta:float) -> void:
	if shield_power > 0:

		shield_power = shield_power - 3 * delta

	if shield_power < 0:

		shield_power = 0
	
	glow.set_shader_parameter("hit_angle", shield_theta)
	glow.set_shader_parameter("hit_fade", shield_power)
	glow.set_shader_parameter("shield_radius", shield_radius)

func _do_tick() -> void:
	pos = up.pos + position + 0.5 * size
	if charge_t == 0 && shield < max_shield:
		shield = shield + shield_charge
		shield_mode = 2
	if shield > max_shield:
		shield = max_shield
		shield_mode = 1
	if shield <= 0:
		shield_mode = 0
		shield = 0
	if charge_t > 0:
		charge_t = charge_t - 1
	
	if up.has_stats: up.stats.update_stats()

func _gen_circle(r:float) -> void:
	var theta := 0.0
	var samples := 0
	var p:Vector2

	shield_line.clear_points()
	samples = round(TAU * r / 10)
	theta = 0

	for i in samples + 1:
		p = Vector2(r * sin(theta),r * cos(theta))
		shield_line.add_point(p)
		theta = theta + TAU / samples

func Hit_shield(d:float, hitp:Vector2) -> void:
	shield = shield - d
	if shield <= 0:
		shield_mode = 0
		shield = 0
	charge_t = max_charge
	shield_power = 1.5 * shield / max_shield + .5
	shield_theta = atan2(hitp.y - pos.y, hitp.x - pos.x)