class_name Target_FOV
extends Area2D

static var FOV_node = preload("res://Game/Unit Life/Target_FOV.tscn")

func _initialize_FOV_area(radius:float) -> void:
	$CollisionShape2D.shape.radius = radius

func _bind_tcpu(tcpu:TargetCPU) -> void:
	area_entered.connect(tcpu._do_FOV_entered)
	area_exited.connect(tcpu._do_FOV_exited)
