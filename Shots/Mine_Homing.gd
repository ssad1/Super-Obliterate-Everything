extends Ship_General

@export var lifespan:int = 20
var life_clock:int = 0
@export var damage:float = 1
@export var force:float = 1
@export var detection_range = 200

@onready var hitbox:Area2D = $detection_hitbox
@onready var detonator = $Detonator

func _ready() -> void:
	armor = max_armor
	is_type = UNIT_STATE.type.MISSILE
	_do_range()
	has_tcpu = tcpu != null
	ai = AI_Behavior.new(self)

	if has_burn: 
		burn = $Burn
		if !burn.visible: 
			burn.show()
	
	hitbox.area_entered.connect(_on_hitbox_entered)
	hitbox.area_exited.connect(_on_hitbox_entered)

func _process(delta:float) -> void:
	if inactive: return
	var blend_pos := position + (pos - position) * 0.1 + 0.2 * velocity
	set_position(blend_pos)
	_do_anim(delta)
	
	_do_tick_clock(delta)

	physics_clock += delta
	if physics_clock > 0.1:
		physics_clock -= 0.1

		_do_physics()

	if physics_clock > 0.2:
		physics_clock = 0.2

func _do_range() -> void:
	range_radius = detection_range
	_add_tcpu()
	
	var tFOV = Target_FOV.FOV_node.instantiate()
	add_child(tFOV)

	tFOV._initialize_FOV_area(detection_range)
	tFOV._bind_tcpu(tcpu)

func _do_tick() -> void:
	life_clock = life_clock + 1
	if life_clock >= lifespan:
		armor = -100
	
	super._do_tick()

func _on_hitbox_entered(area:Area2D):
	if not area is unit_hitbox: return

	var target_unit := (area as unit_hitbox).parent_unit

	if TargetCPU.is_target_eligible(self, target_unit.is_type) && \
		tcpu.check_target(target_unit):
		detonator.death_activate = true

func _on_hitbox_exited(area:Area2D):
	if not area is unit_hitbox: return

	var target_unit := (area as unit_hitbox).parent_unit

	if not TargetCPU.is_target_eligible(self, target_unit.is_type) || \
		not tcpu.check_target(target_unit):
		detonator.death_activate = false