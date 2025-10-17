extends Node2D

var alpha = 0
var dimensions = Vector2(0,0)

func _ready():
	EVENTS.connect("mission_hover_in", Callable(self, "_on_mission_hover_in"))
	EVENTS.connect("mission_hover_out", Callable(self, "_on_mission_hover_out"))
	EVENTS.connect("flipin", Callable(self, "_on_flipin"))
	dimensions = $ColorRect.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(alpha < 1):
		alpha = alpha + 5 * delta
	if(alpha > 1):
		alpha = 1
	modulate = Color(1,1,1,alpha)

func _on_mission_hover_in(m):
	var pos:Vector2 = m.position + m.get_parent().position
	var p := Vector2(pos.x + 20 + 16,pos.y - dimensions.y - 20 + 16)
	if(p.y < 150):
		p.y = 150
	if(p.x + dimensions.x > 1450):
		p.x = pos.x - 16 - dimensions.x
	
	set_position(p)
	
	$Box/Mission_Type.text = m.mission_data[0]
	$Box/Mission_Factions._generate_factions(m.mission_data[1])
	$Box/Mission_Map.text = str(m.mission_data[2])
	$Box/Mission_Size.text = str(m.mission_data[3])
	$Box/Mission_Temperature.text = str(m.mission_data[4])
	$Box/Mission_Difficulty.text = str(m.mission_data[5])
	$Box/Mission_Resources.text = str(m.mission_data[7])
	$Box/Mission_Planet.text = str(m.mission_data[8])
	$Box/Mission_Asteroids.text = str(m.mission_data[9])
	
	alpha = 0
	modulate = Color(1,1,1,alpha)
	show()

func _on_mission_hover_out():
	hide()

func _on_flipin():
	hide()
