extends Shot_General

@export var attraction_force:float = 1
@onready var attraction_area:Area2D = $AttractionArea;
@onready var anim:AnimationPlayer = $AnimationPlayer;
var units_being_atracted:Array = []
var up

func _ready() -> void:
	_init_shot()

	is_type = UNIT_STATE.type.SINGULARITY

	up = get_parent().get_parent()

	if get_parent() is Gun_General: 
		attraction_area.monitoring = false
		attraction_area.monitorable = false

	attraction_area.area_entered.connect(_on_unit_approached)
	attraction_area.area_exited.connect(_on_unit_got_away)
	anim.play("grow")

func _do_death(value:bool) -> void:
	if value:
		velocity = Vector2.ZERO
		var game_arr:Array = SPAWNER.game.get_thing_array(is_type)

		anim.play("evaporate")

		anim.animation_finished.connect(
			func(anim_name:String):
				_remove_ref(spawn_id)
				queue_free()
		)

		tree_exited.connect(func(): game_arr.erase(self))

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

	if units_being_atracted.size() == 0: return

	for i in units_being_atracted.size():

		var unit = units_being_atracted[i]
		var dir:Vector2 = (unit.global_position - global_position).normalized() 
		var dist:float = unit.global_position.distance_to(global_position) 

		if unit.spaghettified:
			unit.velocity *= dir
			unit.global_position = global_position
			continue

		var terminal_velocity:Vector2 = dir * (dist * attraction_force) 
		
		var speed:float = clamp(terminal_velocity.length(), 0.0, unit.max_velocity)
		terminal_velocity = terminal_velocity.normalized() * speed

		unit.velocity -= terminal_velocity

func hit(s) -> void:
	pass

func _on_unit_approached(area:Area2D) -> void:
	#cull all the non-valid options
	if not area is unit_hitbox: return
	#hit logic

	var target := area as unit_hitbox

	if target.parent_unit == up: return
	if target.parent_unit is Shot_General: return

	if tcpu.check_target(target.parent_unit):
		units_being_atracted.append(target.parent_unit)

func _on_unit_got_away(area:Area2D) -> void:
	#cull all the non-valid options
	if not area is unit_hitbox: return

	#hit logic

	var target := area as unit_hitbox

	units_being_atracted.erase(target.parent_unit)

func _remove_ref(s) -> void:
	if tcpu != null:
		tcpu._clean_target(s)

	units_being_atracted.clear()
	up = null

	for i in modules.size():
		if "_remove_ref" in modules[i]:
			modules[i]._remove_ref(s)
