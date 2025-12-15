extends Menu_Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	EVENTS.music_slide.connect(music_slider)
	EVENTS.sound_slide.connect(sound_slider)
	EVENTS.fullscreen.connect(full_screen)
	EVENTS.resolution.connect(resolution)
	EVENTS.quality_change.connect(quality)
	EVENTS.cam_shake.connect(shake)

	hide()
	EVENTS.connect("submenu_button_press",Callable(self,"_submenu_button_press"))

func music_slider(value):
	for i in GLOBAL.music_sliders:
		i.value = value

func sound_slider(value):
	for i in GLOBAL.sound_sliders:
		i.value = value

func full_screen(text):
	for i in GLOBAL.fullscreens:
		i.text = text

func resolution(text):
	for i in GLOBAL.resolutions:
		i.text = text

func quality(text):
	for i in GLOBAL.qualities:
		i.text = text

func shake(text):
	for i in GLOBAL.shakes:
		i.text = text