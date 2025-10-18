extends AudioStreamPlayer2D

@export_range(0.1, 2) var pitch_interval:float = 1
@export var change_pitch: bool = true

func _ready() -> void:
    if !change_pitch: return
    pitch_scale = randf_range(pitch_scale - pitch_interval, pitch_scale + pitch_interval)