extends Shot_General

@export var blow_time:int = 2000
@export var detection_range = 100
@onready var detect_area:Area2D = $Detection_Area;
@onready var anim:AnimationPlayer = $AnimationPlayer;
var about_to_explode:bool = false

func _ready() -> void:
	_init_shot()
	lifespan = blow_time

	detect_area.get_node("CollisionShape2D").shape.radius = detection_range
	detect_area.area_entered.connect(_on_unit_approached)

	hull.frame = randi_range(0, 63)

func _process(delta:float) -> void:
	var blend_pos := position + (pos - position) * .1 + .2 * velocity
	set_position(blend_pos)

	if inactive: return

	tick_clock += delta
	if tick_clock > 0.1:
		tick_clock -= 0.1
		_do_tick()
	if tick_clock > 0.2:
		tick_clock = 0.2
	
	physics_clock += delta
	if physics_clock > 0.1:
		physics_clock -= 0.1

		_do_physics()

		if has_hitbox: hitbox.pos = pos + position

	if physics_clock > 0.2:
		physics_clock = 0.2

func _on_unit_approached(area:Area2D) -> void:
	#cull all the non-valid options
	if not area is unit_hitbox: return

	#hit logic

	var target := area as unit_hitbox

	if tcpu.targets.has(target.parent_unit):
		print("Algo entrou na area")