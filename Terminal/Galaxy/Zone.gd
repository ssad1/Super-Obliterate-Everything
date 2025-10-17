extends Node2D

@export var zone_name = "ZONE"
@export var zone_desc = ""
@export var zone_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TextureButton_pressed():
	SFX._play_new([4003])
	EVENTS.emit_signal("zone_click",zone_name,zone_desc,zone_id)

func _mouse_entered():
	EVENTS.emit_signal("zone_hover_in",self,zone_name)

func _mouse_exited():
	EVENTS.emit_signal("zone_hover_out")
