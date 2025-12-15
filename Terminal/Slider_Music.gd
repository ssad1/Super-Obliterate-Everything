extends HSlider

var saves_on = true

# Called when the node enters the scene tree for the first time.
func _ready():
	saves_on = false
	value = GLOBAL.music_volume
	saves_on = true
	GLOBAL.music_sliders.append(self)

func _on_Slider_Music_value_changed(value):
	GLOBAL.music_volume = value
	if saves_on:
		GLOBAL._save_settings()
	
	EVENTS.music_slide.emit(value)
