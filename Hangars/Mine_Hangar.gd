extends Node2D

@export var release_interval:int = 60
@export var release_delay:float = 1
@export var maximum_releases:int = 2
@export var mine_amount:int = 3
@export var launch_velocity:float = 3
@export var mine_size:float = 1

@onready var total_mines:int = mine_amount * maximum_releases
@onready var up := get_parent()
@onready var pos_offset:Vector2 = position
@onready var rot_offset:float = rotation - up.rotate
@onready var row_timer:Timer = $row_timer

var build_cool:int = 0
var mines:Array[Node2D] = []
var is_type:UNIT_STATE.type = UNIT_STATE.type.HANGAR

var inactive:bool = true

var mine

func _ready() -> void:
	up.modules.append(self)
	mine = get_child(2)

func _do_tick() -> void:

	if mines.size() < total_mines && mines.size() % mine_amount == 0:
		build_cool = build_cool + 1
	else:
		build_cool = 0

	if build_cool >= release_interval:
		_launch_ship(mine_amount)
		build_cool = 0

	rotation = up.rotate + rot_offset

	global_position = up.global_position + pos_offset.rotated(up.rotate)

func _launch_ship(rows:int) -> void:
	while rows > 0:
		spawn_row()
		SFX._play_new([SFX.sound.WEAPON_MINES])
		rows -= 1
		row_timer.start(release_delay)
		await row_timer.timeout

func spawn_row() -> void:

	var obj := SPAWNER._spawn_dupe(
		mine, 
		up.player.id, 
		(up.pos + position),
		Vector2(cos(rotation), sin(rotation)) * launch_velocity + up.velocity,
		0, 
		0, 
		1
	)

	if "detect_area" in obj: 
		obj.detect_area.scale *= Vector2(mine_size, mine_size)
	
	if "has_burn" in obj:
		obj.burn.scale *= Vector2(mine_size, mine_size)

	obj.hull.scale *= Vector2(mine_size, mine_size)
	mines.append(obj)

'''
func _remove_ship(removeid:int) -> void:
	var i
	i = mines.size() - 1
	while(i > -1):
		if(mines[i].spawn_id == removeid):
			mines.remove_at(i)
		i = i - 1
'''
