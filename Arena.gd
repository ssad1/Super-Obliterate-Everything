extends Game

@export var units_blue:Array[SPAWNER.spawn_objs]
@export var units_red:Array[SPAWNER.spawn_objs]
@export var arena_size:Vector2 = Vector2(4096,4096)

var blue_spawn:Vector2 = Vector2(0, 4096/2)
var red_spawn:Vector2 = Vector2(4096, 4096/2)

func _ready() -> void:

	GLOBAL.gamemode = 2

	SPAWNER.game = self
	mapsize = arena_size

	blue_spawn = Vector2(0, arena_size.y/2)
	red_spawn = Vector2(arena_size.x, arena_size.y/2)

	SPAWNER._spawn_player(1,0)
	SPAWNER._spawn_player(2,1)
	SPAWNER._spawn_player(3,0)
	SPAWNER._spawn_player(4,1)
	SPAWNER._spawn_player(5,0)

	for i in units_blue:
		var obj = SPAWNER._spawn(
			[i],
			2,
			blue_spawn,
			Vector2(0,0),
			0,
			0,
			0
		)
	
	for i in units_red:
		var obj = SPAWNER._spawn(
			[i],
			3,
			red_spawn,
			Vector2(0,0),
			0,
			0,
			0
		)
	
func _process(delta:float) -> void:

	_control()
	
	tick_clock = tick_clock + delta
	if tick_clock > 0.1:
		tick_clock = tick_clock - 0.1
		_do_tick()
	if tick_clock > 0.2:
		tick_clock = 0.2
