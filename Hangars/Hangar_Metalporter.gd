extends Node2D

@export var ship_id:Array[SPAWNER.spawn_objs] = [SPAWNER.spawn_objs.METAL_PORTER]
@export var build_max:int = 10
var build_cool:float = 0
@export var ship_max:int = 3
var my_ships = []
var up
var is_type:UNIT_STATE.type = UNIT_STATE.type.HANGAR

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up = get_parent()
	up.modules.append(self)

func _on_death() -> void:
	for i in my_ships.size():
		my_ships[i]._free_base()

func _do_tick() -> void:
	if my_ships.size() < ship_max:
		build_cool = build_cool + 1
	else:
		build_cool = 0
	if build_cool >= build_max and up.metal_storage >= 5:
		_launch_ship()
		build_cool = 0
		up.metal_storage = up.metal_storage - 5

func _launch_ship() -> void:
	var obj = SPAWNER._spawn(ship_id, up.player.id, up.pos + Vector2(0,0), up.velocity + Vector2(0,0), 0, 0, 1)
	my_ships.append(obj)
	obj.base = self

func _remove_ship(removeid:int) -> void:
	'''
	var i := my_ships.size() - 1

	for o in i:
		if my_ships[o].spawn_id == removeid:
			my_ships.remove_at(-o-1) #access properties backward to avoid losing potential units upon deletion
	'''
	var i
	i = my_ships.size() - 1
	while(i > -1):
		if(my_ships[i].spawn_id == removeid):
			my_ships.remove_at(i)
		i = i - 1
