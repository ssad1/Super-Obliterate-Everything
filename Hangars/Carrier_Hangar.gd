extends Node2D

@export var ship_id:Array[SPAWNER.spawn_objs] = []
@export var carrier_interval:int = 60
@export var release_delay:float = 1
@export var maximum_releases:int = 2
@export var ship_amount:int = 3
@export var launch_velocity:float = 3

@onready var total_ships:int = ship_amount * maximum_releases
@onready var up := get_parent()
@onready var pos_offset:Vector2 = position
@onready var rot_offset:float = rotation - up.rotate
@onready var row_timer:Timer = $row_timer

var build_cool:int = 0
var my_ships:Array[Node2D] = []
var is_type:String = "HANGAR"

func _ready() -> void:
	up.modules.append(self)
	ship_id = ship_id.duplicate(true) #avoid the ship_id to be overwritten between all the instances.

func _on_death() -> void:
	for i in my_ships.size():
		my_ships[i]._free_base()

func _do_tick() -> void:

	if my_ships.size() < total_ships && my_ships.size() % ship_amount == 0:
		build_cool = build_cool + 1
	else:
		build_cool = 0

	if build_cool >= carrier_interval:
		_launch_ship(ship_amount)
		build_cool = 0

	rotation = up.rotate + rot_offset

	global_position = up.global_position + pos_offset.rotated(up.rotate)

func _launch_ship(rows:int) -> void:
	while rows > 0:
		spawn_row()
		rows -= 1
		#await get_tree().create_timer(release_delay).timeout
		row_timer.start(release_delay)
		await row_timer.timeout

func spawn_row() -> void:

	var obj := SPAWNER._spawn(
        ship_id, 
        up.player.id, 
        (up.pos + position),
        Vector2(cos(rotation), sin(rotation)) * launch_velocity + up.velocity,
        rotation_degrees, 
        0, 
        1
    )
	my_ships.append(obj)
	obj.base = self
	obj._init_center()


func _remove_ship(removeid:int) -> void:
	var i
	i = my_ships.size() - 1
	while(i > -1):
		if(my_ships[i].spawn_id == removeid):
			my_ships.remove_at(i)
		i = i - 1