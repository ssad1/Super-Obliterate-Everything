extends Ship_Missile

#TODO: make the glow be a mix of all the effects colors
func _ready() -> void:
	super._ready()
	var effect_path = $Module_Trigger/Spawn_Explosion/Explode_Effect
	var effect = effect_path.applied_effects[0]

	var effect_color = UNIT_STATE.effect[effect].primary_color

	if effect_color == null: return

	var glow = $Glow if has_node("Glow") else null

	if not is_instance_valid(glow): return

	glow.modulate = effect_color
	mat.set_shader_parameter("light_color", effect_color)
