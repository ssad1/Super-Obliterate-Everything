extends HSlider

var saves_on = true

# Called when the node enters the scene tree for the first time.
func _ready():
	saves_on = false
	value = GLOBAL.music_volume
	saves_on = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Slider_Music_value_changed(value):
	GLOBAL.music_volume = value
	if(saves_on == true):
		GLOBAL._save_settings()
