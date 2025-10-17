extends Node2D

@onready var Build_Spot = preload("res://Cockpit/Build_Spot.tscn")
@onready var Build_Spot_Ghost = preload("res://Cockpit/Build_Spot_Ghost.tscn")
@onready var Build_Line = preload("res://Cockpit/Build_Line.tscn")

var build_spots = []
var build_spot

# Called when the node enters the scene tree for the first time.
func _ready():
	EVENTS.connect("new_build_spot", Callable(self, "_new_build_spot"))
	EVENTS.connect("cancel_build", Callable(self, "_cancel_build"))
	EVENTS.connect("build_line", Callable(self, "_build_line"))
	EVENTS.connect("build_spot_ghost", Callable(self, "_build_spot_ghost"))
	EVENTS.connect("clear_build_layer", Callable(self, "_clear_all"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var xx = 0
	var yy = 0
	var xshift = 0
	var yshift = 0
	if(SPAWNER.game != null):
		set_position(SPAWNER.game.position)
	if(is_instance_valid(build_spot) == true):
		xshift = (build_spot.dimensions.x - 1) * 16
		yshift = (build_spot.dimensions.y - 1) * 16
		xx = get_global_mouse_position().x - position.x - xshift
		yy = get_global_mouse_position().y - position.y - yshift
		xx = xx - int(floor(xx)) % 32
		yy = yy - int(floor(yy)) % 32
		build_spot.set_position(Vector2(round(xx),round(yy)))

func _new_build_spot(id,v,prices,r,e,sr):
	if(is_instance_valid(build_spot) == true):
		build_spot._die()
		build_spot.queue_free()
		build_spot = null
	build_spot = Build_Spot.instantiate()
	build_spot._ignite(id,v,prices,r,sr)
	add_child(build_spot)
	build_spot.set_position(get_local_mouse_position())
	show()

func _cancel_build():
	if(is_instance_valid(build_spot) == true):
		build_spot._die()
		build_spot.queue_free()
		build_spot = null
	hide()

func _build_line(s,c):
	var l
	l = Build_Line.instantiate()
	l._ignite(s,c)
	add_child(l)

func _build_spot_ghost(s):
	var g
	g = Build_Spot_Ghost.instantiate()
	g._ignite(s)
	add_child(g)

func _clear_all():
	var i
	var a
	i = get_child_count() - 1
	while i > -1:
		get_child(i).queue_free()
		i = i - 1
