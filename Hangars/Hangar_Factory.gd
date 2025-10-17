extends Node2D

@export var ship_id = [2500]
@export var build_max = 60
var build_cool = 0
@export var ship_max = 3
var my_ships = []
var up
var is_type = "HANGAR"

# Called when the node enters the scene tree for the first time.
func _ready():
	up = get_parent()
	up.modules.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_death():
	for i in range(my_ships.size()):
		my_ships[i]._free_base()

func _do_tick():
	if(my_ships.size() < ship_max):
		build_cool = build_cool + 1
	else:
		build_cool = 0
	if(build_cool >= build_max):
		_launch_ship()
		build_cool = 0

func _launch_ship():
	var obj
	obj = SPAWNER._spawn(ship_id, get_parent().player.id, get_parent().pos + Vector2(0,0), get_parent().velocity + Vector2(0,0), 0, 0, 1)
	my_ships.append(obj)
	obj.base = self
	obj._init_center()

func _remove_ship(removeid):
	var i
	i = my_ships.size() - 1
	while(i > -1):
		if(my_ships[i].spawn_id == removeid):
			my_ships.remove_at(i)
		i = i - 1
	
