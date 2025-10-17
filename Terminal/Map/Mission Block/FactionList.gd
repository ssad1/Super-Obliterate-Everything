extends HBoxContainer

@onready var FactionFlag = preload("res://Terminal/Map/Mission Block/FactionFlag.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _clear_factions():
	var a
	while get_child_count() > 0:
		a = get_child(0)
		remove_child(a)
		a.queue_free()
		
func _generate_factions(f):
	var a
	_clear_factions()
	for i in range(f.size()):
		if(f[i] != 0):
			a = FactionFlag.instantiate()
			a._ignite(f[i])
			add_child(a)
