extends Struct_General

var shield_module
@onready var ap:AnimationPlayer = hull.get_node("AnimationPlayer")
@onready var glow:Node2D = hull.get_node("Struct_Shield_Glow")

func _ready() -> void:
	_init_struct()
	shield_module = $Module_Area_Shield

func _do_tick() -> void:
	velocity = Vector2(0,0)
	super._do_tick()
	#TODO ERROR Invalid get index shield at end of match
	if shield_module != null:
		ap.speed_scale = shield_module.shield / shield_module.max_shield
		if shield_module.charge_t == 0 && shield_module.shield < shield_module.max_shield:
			ap.speed_scale = 4
		if shield_module.shield == 0:
			ap.speed_scale = 0

func _process(delta:float) -> void:

	if !is_instance_valid(shield_module): return

	var bright:float = shield_module.shield / shield_module.max_shield
	glow.modulate = Color(.77,.89,1,.7 * bright)
	
	super._process(delta)
