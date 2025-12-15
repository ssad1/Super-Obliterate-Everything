extends HSlider

var saves_on = true

func _ready():
	saves_on = false
	value = GLOBAL.sound_volume
	saves_on = true
	GLOBAL.sound_sliders.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Slider_Sound_value_changed(value):
	GLOBAL.sound_volume = value

	if GLOBAL.gamemode != 0:
		SFX._play_new([SFX.sound.WEAPON_ARTILLERY])
	if saves_on:
		GLOBAL._save_settings()
	
	EVENTS.sound_slide.emit(value)
