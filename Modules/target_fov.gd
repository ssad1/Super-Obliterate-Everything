extends Area2D

func _initialize_FOV_area(radius:float) -> void:
	$CollisionShape2D.shape.radius = radius

func _bind_tcpu(tcpu:TargetCPU) -> void:
	area_entered.connect(tcpu._do_FOV_entered)
	area_exited.connect(tcpu._do_FOV_exited)
	pass
