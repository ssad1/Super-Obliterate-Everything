extends Shot_General

@export var blow_time:int = 2000
@export var detection_range = 100
@onready var detect_area:Area2D = $Detection_Area;
@onready var anim:AnimationPlayer = $AnimationPlayer;
@onready var detonator = $Detonator
var about_to_explode:bool = false

func _ready() -> void:
	_init_shot()
	lifespan = blow_time

	detect_area.get_node("CollisionShape2D").shape.radius = detection_range
	detect_area.area_entered.connect(_on_unit_approached)

	hull.frame = randi_range(0, 63)
	range_radius = detection_range

func _init_shot():

	if has_node("Hull"):
		mat = $Hull.get_material()
		UNIT_STATE.do_unit_build(self, 1.25)

	_calc_damage()
	is_type = UNIT_STATE.type.SHOT

	_do_range()

func _process(delta:float) -> void:
	var blend_pos := position + (pos - position) * .1 + .2 * velocity
	set_position(blend_pos)

	if inactive: return
	
	_do_tick_clock(delta)

	physics_clock += delta
	if physics_clock > 0.1:
		physics_clock -= 0.1

		_do_physics()

	if physics_clock > 0.2:
		physics_clock = 0.2

func _on_unit_approached(area:Area2D) -> void:

	if about_to_explode || inactive: return
	if not area is unit_hitbox: return

	#hit logic

	var target := area as unit_hitbox

	if tcpu.check_target(target.parent_unit):
		detonator.death_activate = true
		about_to_explode = true
		anim.play("detonate")

		anim.animation_finished.connect(
			func(anim_name:String):
				armor = 0
		)
	
