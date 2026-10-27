extends Control

 

func _ignite(f):
	var c
	c = FACTIONS._faction_colors(f)
	$FlagD.modulate = c[0]
	$FlagL.modulate = c[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta:float) -> void:
#	pass
