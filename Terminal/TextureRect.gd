extends TextureRect

func _ready():
	modulate = Color8(255,255,255,50)

#func _process(delta:float) -> void:
#	pass

func _pressed():
	modulate = Color8(255,255,255,255)